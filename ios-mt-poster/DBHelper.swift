//
// Created by Anthony Perritano on 3/10/15.
// Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire
//import Alamofire_SwiftyJSON
import ObjectMapper
import SwiftEventBus

let _sharedMonitor : DBHelper = { DBHelper() }()

class DBHelper: NSObject {

    var allUsers = [User]()
    var allPosters = [Poster]()
    var allPosterItems = [PosterItem]()
    
    var percentComplete : Float = 0.0
    
    class func sharedMonitor() -> DBHelper {
        return _sharedMonitor
    }
    
    override init() {
        super.init()
        
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        
        println("DBHelper Created!");


        
        SVProgressHUD.showProgress(0, status: "Fetching...", maskType: SVProgressHUDMaskType.Gradient)
        fetchUsers()
        fetchPosters()
        fetchPosterItems()
    }
    
    //--- USERS
    
    func fetchUsers() {
        var error: NSError?
        Alamofire.request(.GET, "https://ltg.evl.uic.edu/drowsy/poster/user")
            .responseJSON {
                (request, response, JSON, error) in
                if (error != nil) {
                    NSLog("Error: \(error)")
                } else {
                    NSLog("Success Users")
                    
                    let users = Mapper<User>().mapArray(JSON)
                    
                    self.allUsers = users!
                    
                    NSLog("allUsers \(self.allUsers)")
                    
                    self.percentComplete += 33.3
                    SVProgressHUD.showProgress(self.percentComplete, status: "Fetching...", maskType: SVProgressHUDMaskType.Gradient)
                    
                    self.checkdone()
                    
                }
        }
    }

    func postJSON(userJSON: String!, postType: String!) {

        var url : String = ""

        switch postType {

            case "user":
                url = "https://ltg.evl.uic.edu/drowsy/poster/user"
            case "poster":
                url = "https://ltg.evl.uic.edu/drowsy/poster/poster"
            case "poster_item":
                url = "https://ltg.evl.uic.edu/drowsy/poster/poster_item"
            default:
                println("Type is something else")

        }



        println("starting post")

        
        Alamofire.request(.POST, url, parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as NSMutableURLRequest
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableRequest.HTTPBody = userJSON.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        })).responseJSON{ (request, response, JSON, error) in

            //

            if (error != nil) {
                NSLog("Error: \(error)")
            } else {
                NSLog("Success POST RESPONSE \(response) JSON \(JSON)")
                
                
                let user = Mapper<User>().map(JSON)
                
                if user != nil {
                    self.allUsers.append(user!)
                    SwiftEventBus.post("DBReloadedEvent", sender: nil)
                }
                
                
                
            }
            
            }
        }
    


    func deleteUser(index: Int) {
        var deleteUser = allUsers[index]
        deleteJSON( deleteUser.id, postType: "user")
        allUsers.removeAtIndex(index)
    }


    func deleteJSON(id: String!, postType: String!) {

        var url : String = ""

        switch postType {

        case "user":
            url = "https://ltg.evl.uic.edu/drowsy/poster/user/\(id)"
        case "poster":
            url = "https://ltg.evl.uic.edu/drowsy/poster/poster/\(id)"
        case "poster_item":
            url = "https://ltg.evl.uic.edu/drowsy/poster/poster_item/\(id)"
        default:
            println("Type is something else")

        }



        println("starting delete")


        Alamofire.request(.DELETE, url, parameters: [:]).responseString { (request, response, JSON, error) in

            SwiftEventBus.post("DBReloadedEvent", sender: nil)

            if (error != nil) {
                NSLog("Error: \(error)")
            } else {
                NSLog("Success DELETE \(postType) RESPONSE \(response)")
            }
        }
    }


    func checkdone() {
        if percentComplete > 99.0 {
            SVProgressHUD.dismiss()
            SwiftEventBus.post("DBReloadedEvent", sender: nil)
        }
    }
    
    
    func fetchPostersWithUser(userId: String) -> [Poster] {
        if let user = (allUsers.filter(){ $0.id == userId }.first) {
            return fetchPostersWithUser(user)
        }
        return []
    }
    
    
    func fetchPostersWithUser(user: User) -> [Poster] {

        var filteredPosters = [Poster]()

        if let userPosters = user.posters {
            for userPosterId in userPosters as [String]! {
                if let userPoster = (allPosters.filter(){ $0.id == userPosterId }.first) {
                    filteredPosters.append(userPoster)
                }
            }
        }
        

        return filteredPosters
    }

    
    func fetchPosterItemsWithPoster(poster: Poster) -> [PosterItem]{
        
        var filteredPosterItems = [PosterItem]()
        
        for posterItemId in poster.posterItems as [String]! {
            if let posterItem = (allPosterItems.filter(){ $0.id == posterItemId }.first) {
                filteredPosterItems.append(posterItem)
            }
        }
        
        return filteredPosterItems
        
    }
    
    func fetchPosterItemsWithPoster(posterId: String) -> [PosterItem] {
        if let found = (allPosters.filter(){ $0.id == posterId }.first) {
            return fetchPosterItemsWithPoster(found)
        }
        
        return []
    }



    func fetchPosters() {
        var error: NSError?

        Alamofire.request(.GET, "https://ltg.evl.uic.edu/drowsy/poster/poster")
            .responseJSON {
                (request, response, JSON, error) in
                if (error != nil) {
                    NSLog("Error: \(error)")
                } else {
                    NSLog("Success Posters")
                    
                    let posters = Mapper<Poster>().mapArray(JSON)
                    
                    self.allPosters = posters!
                    
                    NSLog("allPosters \(self.allPosters)")
                    
                    
                    self.percentComplete += 33.3
                    SVProgressHUD.showProgress(self.percentComplete, status: "Fetching...", maskType: SVProgressHUDMaskType.Gradient)
                    self.checkdone()
                }
                
        }

    }
    
    func fetchPosterItems() {
        var error: NSError?
        
        Alamofire.request(.GET, "https://ltg.evl.uic.edu/drowsy/poster/poster_item")
            .responseJSON {
                (request, response, JSON, error) in
                if (error != nil) {
                    NSLog("Error: \(error)")
                } else {
                    NSLog("Success PosterItems")
                    
                    let posters = Mapper<PosterItem>().mapArray(JSON)
                    
                    self.allPosterItems = posters!
                    
                    NSLog("allPosterItems \(self.allPosterItems)")
                    
                    self.percentComplete += 33.3
                    SVProgressHUD.showProgress(self.percentComplete, status: "Fetching...", maskType: SVProgressHUDMaskType.Gradient)
                    self.checkdone()

                }
                
        }
        
    }

}
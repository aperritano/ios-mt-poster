//
// Created by Anthony Perritano on 3/10/15.
// Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire

//import Alamofire_SwiftyJSON

import ObjectMapper
import SwiftyJSON
import Async

let _sharedMonitor: DBHelper = {
    DBHelper()
}()

class DBHelper: NSObject {


    enum URL_TYPE {
        case USER
        case POSTER
        case POSTER_ITEM
    }

    var base_url = "https://ltg.evl.uic.edu/drowsy"
    var allUsers = [User]()
    var allPosters = [Poster]()
    var allPosterItems = [PosterItem]()
    var posterMessageBuilder: PosterMessage!

    var percentComplete: Float = 0.0

    class func sharedMonitor() -> DBHelper {
        return _sharedMonitor
    }

    override init() {
        super.init()

        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)

        println("DBHelper Created!");


        SVProgressHUD.showProgress(0, status: "Fetching...", maskType: SVProgressHUDMaskType.Gradient)
        self.fetchAllCollections()
    }

    func fetchAllCollections() {
        fetchUsers()
        fetchPosters()
        fetchPosterItems()
    }


    func createUser(newUser: User) {
        let JSONString = Mapper().toJSONString(newUser, prettyPrint: false)
        postJSON(JSONString, postType: URL_TYPE.USER, isPostingImage: false)
    }

    func createPoster(newPoster: Poster) {
        let JSONString = Mapper().toJSONString(newPoster, prettyPrint: false)
        postJSON(JSONString, postType: URL_TYPE.POSTER, isPostingImage: false)
    }

    func updateUser(user: User) {


        let JSONString = Mapper().toJSONString(user, prettyPrint: false)

        updateJSON(JSONString, id: user.id!, postType: URL_TYPE.USER)
    }

    func updatePoster(updatePoster: Poster) {
        let JSONString = Mapper().toJSONString(updatePoster, prettyPrint: false)

        updateJSON(JSONString, id: updatePoster.id!, postType: URL_TYPE.POSTER)
    }

    func createUpdateUserWithPoster(userId: String, posterId: String) {
        var fetchedUser = self.fetchUser(userId)
        fetchedUser?.posters?.append(posterId)

        //update
        let JSONString = Mapper().toJSONString(fetchedUser!, prettyPrint: false)

        updateJSON(JSONString, id: userId, postType: URL_TYPE.USER)

    }

    func createPosterItem(posterItem: PosterItem) {
        let JSONString = Mapper().toJSONString(posterItem, prettyPrint: false)

        if posterItem.type == "img" {
            postJSON(JSONString, postType: URL_TYPE.POSTER_ITEM, isPostingImage: true)
        } else {
            postJSON(JSONString, postType: URL_TYPE.POSTER_ITEM, isPostingImage: false)
        }
    }


    func updateJSON(json: String!, id: String, postType: URL_TYPE) {
        println("starting update")

        var url = getDeleteUrl(postType, id: id)

        Alamofire.request(.PUT, url, parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableRequest.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        })).responseJSON {
            (request, response, JSON, error) in

            if (error != nil) {
                NSLog("Error: \(error)")
            } else {
                NSLog("Success UPDAT RESPONSE \(response) JSON \(JSON)")


                switch postType {

                case URL_TYPE.USER:
                    let user = Mapper<User>().map(JSON)

//                    if user != nil {
//                            self.allUsers.append(user!)
//                            self.sendoutEvent(postType)
//                        
//                    }
                case URL_TYPE.POSTER:
                    let poster = Mapper<Poster>().map(JSON)

//                    if poster != nil {
//                        self.allPosters.append(poster!)
//                        self.sendoutEvent(postType)
//                    }
                case URL_TYPE.POSTER_ITEM:
                    let posterItem = Mapper<PosterItem>().map(JSON)
//                    if posterItem != nil {
//                        self.allPosterItems.append(posterItem!)
//                        self.sendoutEvent(postType)
//                    }
                default:
                    println("Type is something else")

                }
            }

        }

    }

    func postJSON(userJSON: String!, postType: URL_TYPE, isPostingImage: Bool) {

        println("starting post")

        var url = getPostUrl(postType)

        if isPostingImage {
            //SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        }


        Alamofire.request(.POST, url, parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableRequest.HTTPBody = userJSON.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        })).responseJSON {
            (request, response, JSON, error) in

            if (error != nil) {
                NSLog("Error: \(error)")
            } else {

                if isPostingImage {
                    SVProgressHUD.dismiss()
                }


                switch postType {

                case URL_TYPE.USER:
                    NSLog("Success POST RESPONSE \(response) JSON \(JSON)")
                    let user = Mapper<User>().map(JSON)

                    if user != nil {
                        self.allUsers.append(user!)
                        self.sendoutEvent(postType)
                    }
                case URL_TYPE.POSTER:
                    NSLog("Success POST RESPONSE \(response) JSON \(JSON)")
                    let poster = Mapper<Poster>().map(JSON)

                    if poster != nil {
                        self.allPosters.append(poster!)
                        self.sendoutEvent(postType)
                    }
                case URL_TYPE.POSTER_ITEM:
                    let posterItem = Mapper<PosterItem>().map(JSON)

                    if posterItem != nil {
                        self.allPosterItems.append(posterItem!)
                        self.sendoutEvent(postType)


                        //send mqtt message

                        self.posterMessageBuilder.posterItemId = posterItem?.id

//                       let JSONString = Mapper().toJSONString(posterItem as PosterItem!, prettyPrint: false)
//

                        self.posterMessageBuilder.action = ADD
                        self.posterMessageBuilder.content = "NEED YOU"
                        self.posterMessageBuilder.type = POSTER_ITEM

                        var finalstring = Mapper().toJSONString(self.posterMessageBuilder, prettyPrint: false)

                        NSLog("FINAL MESSAGE POSTER STRING  \(finalstring)")

                        MQTTPipe.sharedInstance.sendMessage(finalstring)


                    }
                default:
                    println("Type is something else")

                }
            }

        }
    }


    func uploadRequestWithProgress(posterItem: PosterItem!, data: NSData!) {

        var parameters = [
                "file": NetData(data: data!, mimeType: MimeType.ImagePng, filename: posterItem.name!)
        ]


        let URL = "http://ltg.evl.uic.edu:2596/"


        let urlRequest = urlRequestWithComponents(URL, parameters: parameters)

        NSLog("URL REQUEST: \(urlRequest)")
        Alamofire.upload(urlRequest.0, urlRequest.1)
        .progress {
            (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
            println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
        }
        .responseJSON {
            (request, response, JSON, error) in
            println("REQUEST \(request)")
            println("RESPONSE \(response)")
            println("JSON \(JSON)")
            println("ERROR \(error)")
        }


    }


    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
    func urlRequestWithComponents(urlString: String, parameters: NSDictionary) -> (URLRequestConvertible, NSData) {


        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
        let contentType = "multipart/form-data; boundary=----\(boundaryConstant)"
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")



        // create upload data to send
        let uploadData = NSMutableData()

//        ----WebKitFormBoundary7MA4YWxkTrZu0gW
//        Content-Disposition: form-data; name="file"; filename="220.png"
//        Content-Type: image/png


        // add parameters
        for (key, value) in parameters {

            uploadData.appendData("\r\n----\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

            if value is NetData {
                // add image
                var postData = value as! NetData
                uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)



                // append content type
                //uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
                let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
                let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentTypeData!)
                uploadData.appendData(postData.data)

            } else {
                uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)




        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }


    func upload(posterItem: PosterItem!, data: NSData!) {
        var manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/octet-stream"]

        // let imageData: NSMutableData = NSMutableData.appendData(data)


        let URL = "http://ltg.evl.uic.edu:2596/"

        Alamofire.upload(.POST, URL, data)
        .progress {
            (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
            println(totalBytesWritten)
        }
        .responseJSON {
            (request, response, JSON, error) in
            println("request \(request)")
            println("response \(response)")
            println("json \(JSON)")
            println("error \(error)")
        }
    }

    func getDeleteUrl(postType: URL_TYPE, id: String) -> String {
        var url: String = ""

        switch postType {

        case URL_TYPE.USER:
            url = "\(base_url)/poster/user/\(id)"
        case URL_TYPE.POSTER:
            url = "\(base_url)/poster/poster/\(id)"
        case URL_TYPE.POSTER_ITEM:
            url = "\(base_url)/poster/poster_item/\(id)"
        default:
            println("Type is something else")

        }
        return url
    }

    func getPostUrl(postType: URL_TYPE) -> String {
        var url: String = ""

        switch postType {

        case URL_TYPE.USER:
            url = "\(base_url)/poster/user"
        case URL_TYPE.POSTER:
            url = "\(base_url)/poster/poster"
        case URL_TYPE.POSTER_ITEM:
            url = "\(base_url)/poster/poster_item"
        default:
            println("Type is something else")

        }
        return url
    }

    func sendoutEvent(postType: URL_TYPE) {
        switch postType {

        case URL_TYPE.USER:
            SwiftEventBus.post("UserReloadedEvent", sender: nil)
        case URL_TYPE.POSTER:
            SwiftEventBus.post("PosterReloadedEvent", sender: nil)
        case URL_TYPE.POSTER_ITEM:
            SwiftEventBus.post("PosterItemsReloadedEvent", sender: nil)
        default:
            println("Type is something else")

        }

    }


    func deleteJSON(id: String!, postType: URL_TYPE) {

        var url = getDeleteUrl(postType, id: id)

        println("starting delete")


        Alamofire.request(.DELETE, url, parameters: [:]).responseJSON {
            (request, response, JSON, error) in

            if (error != nil) {
                NSLog("Error: \(error)")
            } else {
                NSLog("Success DELETE \(postType) RESPONSE \(response)")
                self.sendoutEvent(postType)
            }

        }
    }


    func checkdone() {
        if percentComplete > 99.0 {
            SVProgressHUD.dismiss()
            SwiftEventBus.post("UserReloadedEvent", sender: nil)
        }
    }

    func deleteUser(index: Int) {
        var deleteUser = allUsers[index]

        for posterId in deleteUser.posters! {
            let p = fetchPoster(posterId)
            Async.background {
                self.deletePoster(p!)
            }
        }


        deleteJSON(deleteUser.id, postType: URL_TYPE.USER)
        allUsers.removeAtIndex(index)
    }

    func deletePoster(poster: Poster) {

        if let index = find(allPosters, poster) {
            allPosters.removeAtIndex(index)
            if let posterItemIds = poster.posterItems {
                for uuid in posterItemIds {
                    if var fp = self.fetchPosterItem(uuid) {
                        self.deleteJSON(fp.id, postType: URL_TYPE.POSTER_ITEM)
                    }
                }
            }


        }

        deleteJSON(poster.id, postType: URL_TYPE.POSTER)

    }

    func deletePosterItem(posterItem: PosterItem) {

        if let index = find(allPosterItems, posterItem) {
            allPosterItems.removeAtIndex(index)
        }

        deleteJSON(posterItem.id, postType: URL_TYPE.POSTER_ITEM)

    }

    func fetchUserWithPosterId(posterId: String) -> User {

        for user in allUsers {

            if let pos = user.posters {
                for pid in pos {

                    if let index = find(pos, pid) {
                        user.posters!.removeAtIndex(index)
                        return user
                    }
                }
            }

        }
        return User()
    }

    func fetchPosterItem(posterItemId: String) -> PosterItem? {
        var posterItem: PosterItem?
        posterItem = (allPosterItems.filter() {
            $0.uuid == posterItemId
        }.first!)
        return posterItem

    }

    func fetchPoster(posterId: String) -> Poster? {
        var poster: Poster?
        poster = (allPosters.filter() {
            $0.uuid == posterId
        }.first!)
        return poster

    }

    func fetchUser(userId: String) -> User? {
        var user: User?
        user = (allUsers.filter() {
            $0.uuid == userId
        }.first!)
        return user

    }

    func fetchPostersWithUser(userId: String) -> [Poster] {
        if let user = fetchUser(userId) {
            return fetchPostersWithUser(user)
        }
        return []
    }


    func fetchPostersWithUser(user: User) -> [Poster] {

        NSLog("fetchPwiU \(user.id) (user.uuid)")
        var filteredPosters = [Poster]()

        if var userPosters = user.posters {
            for userPosterId in userPosters as [String]! {
                if var userPoster = (allPosters.filter() {
                    $0.uuid == userPosterId
                }.first) {
                    filteredPosters.append(userPoster)
                }
            }
        }


        return filteredPosters
    }


    func fetchPosterItemsWithPoster(poster: Poster) -> [PosterItem] {

        var filteredPosterItems = [PosterItem]()

        NSLog("PosterItems: \(poster.posterItems)")
        for posterItemId in poster.posterItems as [String]! {

            for posterItem in allPosterItems {
                if posterItem.uuid == posterItemId {
                    NSLog("found posteritem \(posterItemId)")
                    filteredPosterItems.append(posterItem)
                }
            }
        }

        return filteredPosterItems

    }

    func fetchPosterItemsWithPoster(posterId: String) -> [PosterItem] {

        for poster in allPosters {
            if poster.uuid == posterId {
                NSLog("FOUND poster with posterId \(posterId)")
                return fetchPosterItemsWithPoster(poster)
            }
        }

        return []
    }

    //MARK: FETCHING 

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
//
// Created by Anthony Perritano on 3/10/15.
// Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation

let _sharedMonitor : DBHelper = { DBHelper() }()

class DBHelper: NSObject {

    var users = [User]()
    
    class func sharedMonitor() -> DBHelper {
        return _sharedMonitor
    }
    
    override init() {
        super.init()
        
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        
        println("DBHelper Created!");

        var error: NSError?

        

        request(.GET, "https://ltg.evl.uic.edu/drowsy/poster/user")
        .responseJSON {
            (request, response, data, error) in
            if (error != nil) {
                NSLog("Error: \(error)")

            } else {
                NSLog("Success")
                var responseJSON = JSON(data!)


                for (key: String, userJSON: JSON) in responseJSON {

                    var uid = userJSON["_id"]["$oid"].string
                    var name = userJSON["name"].string

                    var user = User(id: uid!, name: name!)

                    var postersJSON = userJSON["posters"]

                    //If json is .Dictionary
                    for (key: String, posterJSON: JSON) in postersJSON {
                        //Do something you want

                        var pid = posterJSON["id"].string
                        var height = posterJSON["height"].int
                        var width = posterJSON["width"].int
                        var name = posterJSON["name"].string

                        var poster = Poster(id: pid!, height: height!, width: width!, name: name!)
                        
                        user.addPoster(poster)
                        
                        var posterItemsJSON = posterJSON["poster_items"]
                        
                        for (key: String, posterItemJSON: JSON) in posterItemsJSON {
                            var item_id = posterItemJSON["id"].string
                            var x = posterItemJSON["x"].int
                            var y = posterItemJSON["y"].int
                            var width = posterItemJSON["width"].int
                            var height = posterItemJSON["height"].int
                            var name = posterItemJSON["name"].string
                            var image_id = posterItemJSON["image_id"].string
                            var image_bytes = posterItemJSON["image_bytes"].string
                            
                            var posterItem  = PosterItem()
                            posterItem.id = item_id
                            posterItem.x = x
                            posterItem.y = y
                            posterItem.width = width
                            posterItem.height = height
                            posterItem.name = name
                            posterItem.image_bytes = image_bytes
                            posterItem.image_id = image_id
                            
                            poster.addPosterItem(posterItem)
                            
                            
                           
                        }

                        
                        

                        NSLog("POSTER ID: \(pid)")

                        NSLog("POSTER ID: \(pid)")
                        
                       

                    }




                    self.users.append(user)



                    SwiftEventBus.post("DBReloadedEvent", sender: nil)

                    
                    SVProgressHUD.dismiss()

                }

                println("USERS \(self.users)")


            }
        }

    }

    
    func postPosterItem(posterItem: PosterItem!) {
        
//        for (key: String, posterItemJSON: JSON) in posterItemsJSON {
//            var item_id = posterItemJSON["id"].string
//            var x = posterItemJSON["x"].int
//            var y = posterItemJSON["y"].int
//            var width = posterItemJSON["width"].int
//            var height = posterItemJSON["height"].int
//            var name = posterItemJSON["name"].string
//            var image_id = posterItemJSON["image_id"].string
//            var image_bytes = posterItemJSON["image_bytes"].string
        
        
        
//        let parameters = [ 
//            "id": posterItem.id,
//            "x" : posterItem.x]
//            "y" : posterItem.y,
//            "width" : posterItem.width,
//            "height" : posterItem.height,
//            "name" : posterItem.name,
//            "image_id" : posterItem.image_id,
//            "image_bytes": posterItem.image_bytes
//            
    

    }
   

    func fetchPoster(user: User!, poster_id: String!) {

        
        request(.GET, "https://ltg.evl.uic.edu/drowsy/poster/poster", parameters: ["id": poster_id])
        .responseJSON {
            (request, response, data, error) in
            if (error != nil) {
                NSLog("Error: \(error)")

            } else {
                NSLog("Success")
                var json = JSON(data!)

                println("THE POSTER IS \(json)")


                for (key: String, subJson: JSON) in json {
                    println("key \(key) subJson \(subJson)")
//
//                        var uid = subJson["_id"]["$oid"].string
//                        var name = subJson["name"].string
//                        var user = User(id: uid!, name: name!)
//                        self.users.append(user)


                }


            }
        }


    }
//        mConnection = MongoConnection(forServer: "ltg.evl.uic.edu:27017", error: &error)
//        mCollection = mConnection?.collectionWithName("poster.user")

//        var userPredicate = MongoKeyedPredicate()


//
//        var results = mCollection?.findAllWithError(&error) as [BSONDocument]
////        var stringArray: Array<BSONDocument> = Array<BSONDocument>.bridgeFromObjectiveC(results)!
//
//        var dict = BSONDecoder.decodeDictionaryWithDocument(results[0])
//
////        var s = NSStringFromBSONType(dict["_id"])
////
//         var id = dict["_id"] as BSONObjectID
//        var name = dict["name"] as String
//        var posters = dict["posters"] as NSArray
//
//        for p in posters {
//            var k = p as NSDictionary
//            println("dfdf \(k)")
//        }
//
//
//      //  println("dfdf \(id.stringValue())")
//
//
//        var user : User = User(id: id.stringValue(), name: name)
//
//
//        //println("THE USER IS \(user.toString())")
//
//       // var posters = dict["posters"]
//
//
//
//
//
//
//        //var user1 = results[0]
//
//        NSLog("the results \(results)")



    func disconnect() {
        //mConnection?.disconnect()
    }


}



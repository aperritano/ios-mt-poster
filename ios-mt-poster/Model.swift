//
//  Model.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/11/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import ObjectMapper

class User : Mappable {

    var id: String?
    var uid: String?
    var name: String?
    var posters: [String]?
    var nameTags: [String]?
 
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    
    let transform = TransformOf<String, AnyObject>(fromJSON: { (value: AnyObject?) -> String? in
        // transform value from String? to Int?
        
        if value? != nil {
            var newval = value? as NSDictionary
            return newval["$oid"] as String
        }
        
        
        return ""
        }, toJSON: { (value: String?) -> AnyObject? in
            // transform value from Int? to String?
            if let value = value {
                return String(value)
            }
            return nil
    })
    
    // Mappable
    func mapping(map: Map) {
        id      <- (map["_id"], transform)
        uid      <- map["id"]
        name    <- map["name"]
        posters <- map["posters"]
        nameTags <- map["nameTags"]
    }
    
   
}

class Poster : Mappable {
    var id: String?
    var height: Int?
    var width: Int?
    var posterItems: [String]?
    var name: String?

    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        height      <- map["height"]
        width       <- map["width"]
        posterItems <- map["posterItems"]
    }
}


class PosterItem : Mappable {
    var id: String?
    var x: Int?
    var y: Int?
    var width: Int?
    var height: Int?
    var name: String?
    var rotation: Int?
    var image_id: String?
    var image_bytes: String?
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        x           <- map["x"]
        y           <- map["y"]
        height      <- map["height"]
        width       <- map["width"]
        rotation    <- map["rotation"]
        image_id    <- map["imageId"]
        image_bytes <- map["imageBytes"]
    }
 
}

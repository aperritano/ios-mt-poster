//
//  Model.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/11/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import ObjectMapper

let transform = TransformOf<String, AnyObject>(fromJSON: { (value: AnyObject?) -> String? in
    // transform value from String? to Int?
    
    if value? != nil {
        var newval = value? as NSDictionary
        return newval["$oid"] as String!
    }
    
    
    return ""
    }, toJSON: { (value: String?) -> AnyObject? in
        // transform value from Int? to String?
        if let value = value {
            
            let ids:NSDictionary = ["$oid": String(value)]
            
            return ids
        }
        return nil
})


class PosterMessage : Mappable {
    var type: String?
    var content: String?
    var action: String?
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        content <- map["content"]
        action <- map["action"]
    }
    
}

class User : Mappable, Equatable {

    var id: String?
    var uuid: String?
    var name: String?
    var posters: [String]?
    var nameTags: [String]?
 
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    

    
    // Mappable
    func mapping(map: Map) {
        id      <- (map["_id"], transform)
        uuid      <- map["uuid"]
        name    <- map["name"]
        posters <- map["posters"]
        nameTags <- map["nameTags"]
    }
    
   
   
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.uuid == rhs.uuid
}

func ==(lhs: Poster, rhs: Poster) -> Bool {
    return lhs.uuid == rhs.uuid
}

func ==(lhs: PosterItem, rhs: PosterItem) -> Bool {
    return lhs.uuid == rhs.uuid
}

class Poster : Mappable,  Equatable {
    var id: String?
    var uuid: String?
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
        id      <- (map["_id"], transform)
        uuid          <- map["uuid"]
        name        <- map["name"]
        height      <- map["height"]
        width       <- map["width"]
        posterItems <- map["posterItems"]
    }
}


class PosterItem : Mappable,  Equatable {
    var id: String?
    var uuid: String?
    var x: Int?
    var y: Int?
    var width: Int?
    var height: Int?
    var name: String?
    var rotation: Int?
    var content: String?
    var type: String?
    var image_bytes: String?
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    func mapping(map: Map) {
        id      <- (map["_id"], transform)
        uuid          <- map["uuid"]
        name        <- map["name"]
        x           <- map["x"]
        y           <- map["y"]
        height      <- map["height"]
        width       <- map["width"]
        rotation    <- map["rotation"]
        content     <- map["content"]
        type        <- map["type"]
        image_bytes <- map["imageBytes"]
    }
 
}

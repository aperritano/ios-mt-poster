//
//  Model.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/11/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation

class User {

    var id: String?
    var name: String?
    var posters: [Poster] = [Poster]()
    
    init(id: String!, name: String!) {
        self.id = id
        self.name = name
    }

    func addPoster(poster: Poster?) {
        posters.append(poster!)
    }

    func toString() -> String {
        return "User with id: \(id) name: \(name)"
    }
}

class Poster {
    var id: String?
    var height: Int?
    var width: Int?
    var posterItems: [PosterItem] = [PosterItem]()
    var name: String?

    init(id: String, height: Int, width: Int, name: String) {
        self.id = id
        self.height = height
        self.width = width
        self.name = name
    }

    func addPosterItem(posterItem: PosterItem) {
        posterItems.append(posterItem)
    }

}


class PosterItem {
    var id: String?
    var x: Int?
    var y: Int?
    var width: Int?
    var height: Int?
    var name: String?
    var image_id: String?
    var image_bytes: String?
    
    init() {
        
    }
    
    init(id: String, x: Int, y: Int, width: Int, height: Int, name: String, image_id: String, image_bytes: String) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.name = name
        self.image_id = image_id
        self.image_bytes = image_bytes
    }
    
}

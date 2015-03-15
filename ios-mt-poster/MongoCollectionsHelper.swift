//
//  MongoCollectionsHelper.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/14/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation

class MongoCollectionHelper: NSObject {

    override init() {
        super.init()
        SwiftEventBus.post("login", sender: nil)

    }
}
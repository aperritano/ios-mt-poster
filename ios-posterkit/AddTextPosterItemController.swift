//
//  ViewController.swift
//  ios-mqtt-base
//
//  Created by Anthony Perritano on 6/10/14.
//  Copyright (c) 2014 LTG. All rights reserved.
//

import UIKit


class AddTextPosterItemController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var posterNameTextField: UITextView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func shouldAutorotate() -> Bool {
        return false
    }


}


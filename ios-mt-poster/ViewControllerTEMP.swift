//
//  ViewController.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 2/28/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        var dynamicView = UIView(frame: CGRectMake(200, 500, 100, 100))
        dynamicView.backgroundColor = UIColor.greenColor()
        dynamicView.layer.cornerRadius = 25
        dynamicView.layer.borderWidth = 2
        self.mainView.addSubview(dynamicView)

//
//        var styleView = BallUIView(frame: CGRectMake(100, 100, 125, 125))
//        styleView.baseColor = UIColor.paperColorGreenA100()


//        self.mainView.addSubview(styleView)
//        styleView.setNeedsLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()


        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

//
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
//                self.navigationController?.navigationBar.tintColor = UIColor.blueColor()
//        self.navigationController?.navigationBar.barTintColor = UIColor.blueColor()
//        self.navigationController?.navigationBar.translucent = false;
//        
//        
//        UINavigationBar.appearance().barTintColor = UIColor.paperColorGray900()


//        if let font = UIFont(name: "RobotoCondensed-Regular", size: 20) {
//            self.navigationController?.navigationBar.titleTextAttributes =
//                [NSFontAttributeName: font,
//                    NSForegroundColorAttributeName: UIColor.paperColorGray900()]
//        }
//        
//
//     
        // UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

    }

//
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.Default
//    }
}


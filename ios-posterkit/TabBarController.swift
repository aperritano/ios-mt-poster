//
//  TabBarController.swift
//  FrostedSidebar
//
//  Created by Evan Dekhayser on 8/28/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var sidebar: FrostedSidebar!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.hidden = true

        sidebar = FrostedSidebar(itemImages: [
                UIImage(named: "profile")!,
                UIImage(named: "gear")!],
                colors: [
                        UIColor.paperColorGreen400(),
                        UIColor.paperColorBlue400()],
                selectedItemIndices: NSIndexSet(index: 0))

        sidebar.isSingleSelect = true
        sidebar.actionForIndex = [
                0: {
                    self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 0 })
                },
                1: {
                    self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 1 })
                }]
    }

}

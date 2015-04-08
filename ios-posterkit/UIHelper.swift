//
// Created by Anthony Perritano on 3/10/15.
// Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import UIKit

let _uihelper: UIHelper = {
    UIHelper()
}()

class UIHelper: NSObject {

    class func getHelp() -> UIHelper {
        return _uihelper
    }

    override init() {
        super.init()
    }

    func showAlert(uicontroller: UIViewController, message: String) {
        var alert = UIAlertController(title: "ERROR ERROR", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "dooh!", style: UIAlertActionStyle.Default, handler: nil))
        uicontroller.presentViewController(alert, animated: true, completion: nil)
    }
}
//
//  AddUserController.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/21/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import UIKit

class AddUserController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet var userNameTextField : UITextField!
    @IBOutlet var nameTagTextField : UITextField!
    @IBOutlet var posterNameTextField : UITextField!

    
    @IBOutlet weak var addMaterialButton: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.becomeFirstResponder()
    }

}

//
//  AddPosterController.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/22/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import UIKit

class AddPosterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet var posterNameTextField : UITextField!
    
    
    @IBOutlet weak var addMaterialButton: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterNameTextField.becomeFirstResponder()
    }
    
}

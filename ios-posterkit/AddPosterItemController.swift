//
//  ViewController.swift
//  ios-mqtt-base
//
//  Created by Anthony Perritano on 6/10/14.
//  Copyright (c) 2014 LTG. All rights reserved.
//

import UIKit
import Photos

class AddPosterItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    


    var selectedImage: UIImage?
    var fileUploadBackgroundTaskId : UIBackgroundTaskIdentifier?

    let tapRecognizer = UITapGestureRecognizer()
    var url : NSURL!

    @IBOutlet weak var posterImageView: UIImageView!
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //tap
        //tapRecognizer.addTarget(self, action: "selectImageFromLibrary")
        
        
        posterImageView.backgroundColor = UIColor.paperColorGray300()
        posterImageView.layer.borderColor = UIColor.paperColorGray300().CGColor
        posterImageView.layer.borderWidth =  1
        posterImageView.layer.cornerRadius = 3
        
       //posterImageView.addGestureRecognizer(tapRecognizer)

    }
    
    @IBAction func imageViewTap(sender: UITapGestureRecognizer) {
        self.selectImageFromLibrary()
    }
    func selectImageFromLibrary() {
        
        var picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        var ipop = UIPopoverController(contentViewController: picker)
        ipop.presentPopoverFromRect(self.posterImageView.bounds, inView: self.posterImageView, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        selectedImage = image
        posterImageView.image = image
        picker.dismissViewControllerAnimated(true , completion: nil)
    }
    
}


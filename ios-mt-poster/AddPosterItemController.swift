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
    
    @IBOutlet var topicTextField : UITextField!
    @IBOutlet var messageTextField : UITextField!
    @IBOutlet weak var posterImageView: UIImageView!

    var selectedImage: UIImage?
    var fileUploadBackgroundTaskId : UIBackgroundTaskIdentifier?

    let tapRecognizer = UITapGestureRecognizer()

    let uploadQueue : NSOperationQueue!
    var url : NSURL!

    @IBOutlet weak var sendMaterialButton: MKButton!
    
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
    @IBAction func addPosterItemAction(sender: AnyObject) {
    }
    
    @IBAction func cancelAction(sender: UIButton) {
    }
    
    @IBAction func sendImageToPoster(sender: UIButton) {
        println("HEY THERE")

 
//        // Create a thumbnail and add a corner radius for use in table views
//        UIImage *thumbnailImage = [anImage thumbnailImage:86.0f
//        transparentBorder:0.0f
//        cornerRadius:10.0f
//        interpolationQuality:kCGInterpolationDefault];
//
//        // Get an NSData representation of our images. We use JPEG for the larger image
//        // for better compression and PNG for the thumbnail to keep the corner radius transparency
//        NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
//        NSData *thumbnailImageData = UIImageJPEGRepresentation(thumbnailImage, 0.8f);
//
//        if (!imageData || !thumbnailImageData) {
//            return NO;
//        }
//
//        var reducedImage = UIImageJPEGRepresentation(selectedImage, 5.0)
//        var pfile = PFFile(data: reducedImage)
//        var bgTask = UIBackgroundTaskIdentifier()
//
//        var gameScore = PFObject(className: "Photo")
//        gameScore.setObject(pfile, forKey: "image")
//        gameScore.saveInBackgroundWithBlock {
//            (success: Bool!, error: NSError!) -> Void in
//            if (success != nil) {
//                NSLog("Object created with id: \(gameScore.objectId)")
//            } else {
//                NSLog("%@", error)
//            }
//        }
//        
//        bgTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
//            UIApplication.sharedApplication().endBackgroundTask(bgTask)
//        }
//
//        gameScore.saveInBackgroundWithBlock { (success: Bool!, error: NSError!) -> Void in
//            if (success != nil) {
//                NSLog("Object created with id: \(gameScore.objectId)")
//            } else {
//                NSLog("%@", error)
//            }
//            UIApplication.sharedApplication().endBackgroundTask(bgTask)
//        }


    

        
    }
    
    func printConsole(sender: AnyObject) {
        
//        var query = PFQuery(className: "Photo")
//        
//        var o = query.getFirstObject()
//        
//        NSLog("%@", o.objectId as NSString)
        
//        query.getObjectInBackgroundWithId(gameScore.objectId) {
//            (scoreAgain: PFObject!, error: NSError!) -> Void in
//            if (scoreAgain != nil) {
//                NSLog("%@", scoreAgain.objectForKey("objectId") as NSString)
//            } else {
//                NSLog("%@", error)
//            }
//        }
    }

    func sendMessage(sender : AnyObject) {
        
        if messageTextField.text != nil {
            
            println("message \(messageTextField.text)")

        //    MQTTPipe.sharedInstance.sendMessage(messageTextField.text)
        }
        
    }

    func subscribeTopic(sender : AnyObject) {
        
        if (topicTextField.text != nil) {
            
            println("topic \(topicTextField.text)")
            
          //  MQTTPipe.sharedInstance.subscribeTopic(topicTextField.text)
        }
    }
}


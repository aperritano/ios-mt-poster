//
//  PosterItemCollectionController.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/14/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import UIKit
import CCMPopup
import Async
import ObjectMapper
import Alamofire

class PosterItemCollectionController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var selectedPosterId: String?
    var popupController: AddPosterItemController?


    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    var selectedColor: UIColor?
    var isDoingEditing = false


    override func viewDidLoad() {
        super.viewDidLoad()


        UINavigationBar.appearance().barTintColor = UIColor.paperColorGray600()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        SwiftEventBus.onMainThread(self, name: "PosterItemsReloadedEvent") {
            _ in
            self.reloadWithDBHelper()
        }
    }

    func reloadWithDBHelper() {
        self.collectionView?.reloadData()

    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DBHelper.sharedMonitor().fetchPosterItemsWithPoster(selectedPosterId!).count
    }


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "addPosterItemSegue" {
            var popupSegue: CCMPopupSegue = segue as! CCMPopupSegue
            if self.view.bounds.size.height < 420 {
                popupSegue.destinationBounds = CGRectMake(0, 0, ((UIScreen.mainScreen().bounds.size.height - 20) * 0.75), (UIScreen.mainScreen().bounds.size.height - 20))
            } else {
                popupSegue.destinationBounds = CGRectMake(0, 0, 600, 620)
            }
            popupSegue.backgroundBlurRadius = 7
            popupSegue.backgroundViewAlpha = 0.9
            popupSegue.backgroundViewColor = UIColor.paperColorGray400()
            popupSegue.dismissableByTouchingBackground = true
            self.popupController = popupSegue.destinationViewController as? AddPosterItemController

        } else if segue.identifier == "addTextSegue" {
            var popupSegue: CCMPopupSegue = segue as! CCMPopupSegue
            if self.view.bounds.size.height < 420 {
                popupSegue.destinationBounds = CGRectMake(0, 0, ((UIScreen.mainScreen().bounds.size.height - 20) * 0.75), (UIScreen.mainScreen().bounds.size.height - 20))
            } else {
                popupSegue.destinationBounds = CGRectMake(0, 0, 600, 400)
            }
            popupSegue.backgroundBlurRadius = 7
            popupSegue.backgroundViewAlpha = 0.9
            popupSegue.backgroundViewColor = UIColor.paperColorGray400()
            popupSegue.dismissableByTouchingBackground = true
            // self.popupController = popupSegue.destinationViewController as? AddTextPosterItemController
        }


    }


    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: PosterItemCell = collectionView.dequeueReusableCellWithReuseIdentifier("PosterItemCell", forIndexPath: indexPath) as! PosterItemCell
        let color = UIColor.paperColorOrange400()

        let posterItems = DBHelper.sharedMonitor().fetchPosterItemsWithPoster(selectedPosterId!)

        let posterItem = posterItems[indexPath.row]

        cell.title.text = posterItem.name

        if posterItem.type == "txt" {
            cell.contentLabel.text = posterItem.content

            cell.posterImage.image = nil

        } else if posterItem.type == "img" {
            if let url = posterItem.content {
                cell.posterImage.downloadImage(url)
            } else {
                UIHelper.getHelp().showAlert(self, message: "the url for image was nil")
            }
        }
        cell.removeButton.hidden = !isDoingEditing
        cell.removeButton.tag = indexPath.row;
        cell.backgroundColor = color
        return cell

    }

    @IBAction func popoverCancelButton(segue: UIStoryboardSegue) {

        if let posterItemController = segue.sourceViewController as? AddPosterItemController {
            posterItemController.dismissAnimated()
        } else if let posterItemController = segue.sourceViewController as? AddPosterItemController {
            posterItemController.dismissAnimated()
        }

    }

    @IBAction func popoverAddTextButton(segue: UIStoryboardSegue) {
        if let addPosterItemController = segue.sourceViewController as? AddTextPosterItemController {
            addPosterItemController.dismissViewControllerAnimated(true, completion: {

                var mqttPosterItems = [PosterItem]()
                var selectedPoster = DBHelper.sharedMonitor().fetchPoster(self.selectedPosterId!)
                if let titleMessage = addPosterItemController.posterNameTextField.text {
                    var posterItem = PosterItem()
                    posterItem.uuid = NSUUID().UUIDString
                    posterItem.x = 500
                    posterItem.y = 500
                    posterItem.width = 500
                    posterItem.height = 500
                    posterItem.name = "PI-\(Int(arc4random_uniform(50)))"
                    posterItem.type = "txt"
                    posterItem.content = titleMessage
                    selectedPoster?.posterItems?.append(posterItem.uuid!)
                    mqttPosterItems.append(posterItem)
                    Async.background {
                        DBHelper.sharedMonitor().createPosterItem(posterItem)
                    }.background {
                        let JSONString = Mapper().toJSONString(posterItem, prettyPrint: false)
                        var mp = PosterMessage()
                        mp.action = "add"
                        mp.content = JSONString
                        mp.type = "poster_item"

                        var finalstring = Mapper().toJSONString(mp, prettyPrint: false)

                        MQTTPipe.sharedInstance.sendMessage(finalstring)


                        NSLog("PRINTING \(finalstring)")
                    }


                }





                Async.background {


                    DBHelper.sharedMonitor().updatePoster(selectedPoster!)

                }
            })
        }

    }


    @IBAction func popoverAddButton(segue: UIStoryboardSegue) {
        if let addPosterItemController = segue.sourceViewController as? AddPosterItemController {
            addPosterItemController.dismissViewControllerAnimated(true, completion: {

                var mqttPosterItems = [PosterItem]()
                var selectedPoster = DBHelper.sharedMonitor().fetchPoster(self.selectedPosterId!)

                if let imageData = UIImagePNGRepresentation(addPosterItemController.posterImageView.image) {
                    let base64String = imageData.base64EncodedStringWithOptions(.allZeros)

                    var posterItem = PosterItem()
                    posterItem.uuid = NSUUID().UUIDString
                    posterItem.x = 500
                    posterItem.y = 500
                    posterItem.width = 500
                    posterItem.height = 500
                    posterItem.name = "pi\(Int(arc4random_uniform(50))).png"
                    posterItem.type = "img"
                    posterItem.content = "image"
                    posterItem.image_bytes = base64String
                    // posterItem.image_id = "png"
                    selectedPoster?.posterItems?.append(posterItem.uuid!)

                    mqttPosterItems.append(posterItem)

                    Async.background {
//                         DBHelper.sharedMonitor().upload(posterItem, data: imageData)
                        DBHelper.sharedMonitor().uploadRequestWithProgress(posterItem, data: imageData)
                    }
                    Async.background {
                        //DBHelper.sharedMonitor().createPosterItem(posterItem)
                    }

                }



                Async.background {
                    //DBHelper.sharedMonitor().updatePoster(selectedPoster!)
                }

            })
        }

    }

    @IBAction func DeleteCellAction(sender: MKButton) {

        SweetAlert().showAlert("Are you sure?", subTitle: "This POSTER ITEM will be permanently delete!", style: AlertStyle.Warning, buttonTitle: "Cancel", buttonColor: UIColor.paperColorBlue400(), otherButtonTitle: "YES", otherButtonColor: UIColor.paperColorRed()) {
            (isOtherButton) -> Void in
            if isOtherButton == true {
                println("Cancel Button  Pressed")
            } else {

                var posterItemId: String?
                var posterItems = DBHelper.sharedMonitor().fetchPosterItemsWithPoster(self.selectedPosterId!)

                var indexPath: NSIndexPath = self.collectionView.indexPathForItemAtPoint(self.collectionView.convertPoint(sender.center, fromView: sender.superview))!




                var selectedPosterItem = posterItems[indexPath.row]
                posterItemId = selectedPosterItem.uuid!


                Async.background {


                    DBHelper.sharedMonitor().deletePosterItem(selectedPosterItem)


                }.background {
                    var selectedPoster = DBHelper.sharedMonitor().fetchPoster(self.selectedPosterId!)

                    var localPosterItems = selectedPoster?.posterItems as [String]!
                    if let index = find(localPosterItems, posterItemId!) {
                        selectedPoster?.posterItems?.removeAtIndex(index)
                        DBHelper.sharedMonitor().updatePoster(selectedPoster!)
                    }
                }.main {
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                    self.collectionView.reloadData()
                    self.isDoingEditing = false
                    self.editButton.tintColor = UIColor.paperColorBlue400()
                    SweetAlert().showAlert("Deleted!", subTitle: "This user has been deleted!", style: AlertStyle.Success)
                }
            }


        }


    }

    @IBAction func toggleEditMode(sender: UIBarButtonItem) {
        if isDoingEditing == false {
            isDoingEditing = true
            sender.tintColor = UIColor.paperColorRed()
        } else {
            isDoingEditing = false
            sender.tintColor = UIColor.paperColorBlue400()
        }

        self.reloadWithDBHelper()
    }

//    func sendMessage(sender : AnyObject) {
//        
//        if messageTextField.text != nil {
//            
//            println("message \(messageTextField.text)")
//            
//            //    MQTTPipe.sharedInstance.sendMessage(messageTextField.text)
//        }
//        
//    }
//    
//    func subscribeTopic(sender : AnyObject) {
//        
//        if (topicTextField.text != nil) {
//            
//            println("topic \(topicTextField.text)")
//            
//            //  MQTTPipe.sharedInstance.subscribeTopic(topicTextField.text)
//        }
//    }


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

    @IBAction func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }

}

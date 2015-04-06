//
//  UserCollectionViewController.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/14/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import BFPaperCollectionViewCell
import UIColor_BFPaperColors
import ObjectMapper
import CCMPopup
import Async
import WYPopoverController

class UserCollectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WYPopoverControllerDelegate {
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var isDoingEdits = false
    var popupController: AddUserController?

    
    override func viewDidLoad() {
        
        UINavigationBar.appearance().barTintColor = UIColor.paperColorGray600()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        
       DBHelper.sharedMonitor().posterMessageBuilder = PosterMessage()
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)

        SwiftEventBus.onMainThread(self, name: "UserReloadedEvent") { _ in
            self.reloadWithDBHelper()
        }
    }
    
    func reloadWithDBHelper() {
        self.collectionView?.reloadData()

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.collectionViewLayout.invalidateLayout()
        return DBHelper.sharedMonitor().allUsers.count
    }
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
         return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        NSLog("cell path \(indexPath.row)")

        var itemNumber = indexPath.item

        var cell : UserCell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        let color = UIColor.paperColorBlue500()
        var foundUser: User? = DBHelper.sharedMonitor().allUsers[indexPath.row];
        
        if let goodUser = foundUser {
            cell.title.text = goodUser.name
            
            if( goodUser.nameTags != nil)  {
                cell.nameTags.text = ",".join(goodUser.nameTags!)
            }
            
            cell.removeButton.hidden = !isDoingEdits
            cell.removeButton.tag = indexPath.row;
            cell.backgroundColor = color
        }
      //  NSLog("cell is \(cell) with \(indexPath.row)")
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "posterSegue"{
            let vc = segue.destinationViewController as! PosterCollectionController
            let cell = sender as! UserCell
            let user = DBHelper.sharedMonitor().allUsers.filter(){ $0.name == cell.title.text }.first!
            DBHelper.sharedMonitor().posterMessageBuilder.userUuid = user.uuid
            vc.selectedUserId = user.uuid
            vc.selectedColor = cell.backgroundColor                    
        } else if segue.identifier == "addUserSegue" {

//            var popoverSegue : WYStoryboardPopoverSegue = segue as! WYStoryboardPopoverSegue
//            var vc = segue.destinationViewController as! AddUserController
//            vc.preferredContentSize =  CGSizeMake(650, 350)
//            popupController  =  popoverSegue.popoverControllerWithSender(sender, permittedArrowDirections:WYPopoverArrowDirection.Any, animated:true)
//
//popoverController = [popoverSegue popoverControllerWithSender:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
//popoverController.delegate = self;

            var popoverSegue: CCMPopupSegue = segue as! CCMPopupSegue
            if self.view.bounds.size.height < 420 {
                popoverSegue.destinationBounds = CGRectMake(0, 0, ((UIScreen.mainScreen().bounds.size.height-20) * 0.75), (UIScreen.mainScreen().bounds.size.height-20))
            } else {
                popoverSegue.destinationBounds = CGRectMake(0, 0, 650, 350)
            }
            popoverSegue.backgroundBlurRadius = 7
            popoverSegue.backgroundViewAlpha = 0.9
            popoverSegue.backgroundViewColor = UIColor.paperColorGray400()
            popoverSegue.dismissableByTouchingBackground = true
            self.popupController = popoverSegue.destinationViewController as? AddUserController

        }
    }


    @IBAction func toggleEditMode(sender: UIBarButtonItem) {
        if isDoingEdits == false {
            isDoingEdits = true
            sender.tintColor = UIColor.paperColorRed()
        } else {
            isDoingEdits = false
            sender.tintColor = UIColor.paperColorBlue400()
        }
        
         self.reloadWithDBHelper()
    }
    @IBAction func DeleteCellAction(sender: MKButton) {

        SweetAlert().showAlert("Are you sure?", subTitle: "This user and all of its posters will be permanently deleted!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColor.paperColorBlue400() , otherButtonTitle:  "YES", otherButtonColor: UIColor.paperColorRed()) { (isOtherButton) -> Void in
            if isOtherButton == true {                
                println("Cancel Button  Pressed")
            } else {
                
                self.collectionView.performBatchUpdates({
                    
                    var indexPath : NSIndexPath = self.collectionView.indexPathForItemAtPoint(self.collectionView.convertPoint(sender.center, fromView: sender.superview))!
                    DBHelper.sharedMonitor().deleteUser(indexPath.row)
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                    self.isDoingEdits = false
                    self.editButton.tintColor = UIColor.paperColorBlue400()
                    } , completion: nil)
                
                SweetAlert().showAlert("Deleted!", subTitle: "", style: AlertStyle.Success)
            }
        }
        
        
       

    }
    
    
    @IBAction func popoverCancelButton(segue:UIStoryboardSegue) {
        var addController = segue.sourceViewController as! AddUserController
        addController.dismissAnimated()
    }
    
    @IBAction func popoverAddButton(segue:UIStoryboardSegue) {
        
        
        
        var addController = segue.sourceViewController as! AddUserController
        
        addController.dismissViewControllerAnimated(true, completion: {
        
            var username = addController.userNameTextField.text
            var nameTags = addController.nameTagTextField.text
            var poster   = addController.posterNameTextField.text
            
            if !username.isEmpty && !nameTags.isEmpty {
                var newUser = User()
                newUser.uuid = NSUUID().UUIDString
                newUser.name = username
                newUser.nameTags = nameTags.componentsSeparatedByString(",")
                
                var newPoster =  Poster()
                
                if !poster.isEmpty  {
                    newPoster.name = poster
                } else {
                    newPoster.name = "Hello Poster \(Int(arc4random_uniform(10)))"
                }
                
                newPoster.uuid = NSUUID().UUIDString
                newPoster.height = 1583
                newPoster.width = 2876
                newPoster.posterItems = []
        
                
                newUser.posters = [ newPoster.uuid! ]
                
             
                Async.background {                
                    DBHelper.sharedMonitor().createUser(newUser)
                }.background {
                    DBHelper.sharedMonitor().createPoster(newPoster)
                }                                        

            }
            
                    
        })
        
    }
    @IBAction func refreshTheInterface(sender: UIBarButtonItem) {
        DBHelper.sharedMonitor().fetchAllCollections()
    }

    @IBAction func GoJoe() {
        
       
        var posterItem = PosterItem()
        
        posterItem.uuid = NSUUID().UUIDString
        posterItem.height = 1583
        posterItem.width = 2876
        posterItem.x = 100
        posterItem.y = 100
        posterItem.height = 250
        posterItem.width = 200
        posterItem.type = "txt"
        posterItem.content = "HELLLO"
        
        let JSONString = Mapper().toJSONString(posterItem, prettyPrint: false)

        
        var mp = PosterMessage()
        mp.action = "add"
        mp.content = JSONString
        mp.type = "poster_item"
        
        var finalstring = Mapper().toJSONString(mp, prettyPrint: false)
        
        MQTTPipe.sharedInstance.sendMessage(finalstring)

            
             NSLog("PRINTING \(finalstring)" )
        
        
        

        

    }
    
    @IBAction func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
   
    
}

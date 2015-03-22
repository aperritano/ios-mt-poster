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
import SwiftEventBus
import ObjectMapper
import CCMPopup
import Async

class UserCollectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var nameLabels : [String] = ["GROUP 1", "GROUP 2", "GROUP 3","GROUP 4","GROUP 5","GROUP 6","GROUP 7","GROUP 8","GROUP 8"]
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var isEditing = false
    
    var colors: [UIColor] = [UIColor.paperColorRed400(), UIColor.paperColorIndigo400(), UIColor.paperColorPink400(), UIColor.paperColorLightBlue400(), UIColor.paperColorAmber400(), UIColor.paperColorOrange400(), UIColor.paperColorBrown400(), UIColor.paperColorTeal400(), UIColor.paperColorPink400(), UIColor.paperColorBlue400(), UIColor.paperColorGray400(), UIColor.paperColorDeepPurple400(), UIColor.paperColorGreen400()]
    
    
    var popupController: AddUserController?

    
    override func viewDidLoad() {
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
        return DBHelper.sharedMonitor().allUsers.count
    }
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
         return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UserCell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath: indexPath) as UserCell
        let color = colors[indexPath.row]
        var foundUser = DBHelper.sharedMonitor().allUsers[indexPath.row];
        cell.title.text = foundUser.name
        
        if( foundUser.nameTags != nil)  {
            cell.nameTags.text = ",".join(foundUser.nameTags!)
        }

        cell.removeButton.hidden = !isEditing
        cell.removeButton.tag = indexPath.row;
        cell.backgroundColor = color
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "posterSegue"{
            let vc = segue.destinationViewController as PosterCollectionController
            let cell = sender as UserCell
            let user = DBHelper.sharedMonitor().allUsers.filter(){ $0.name == cell.title.text }.first!
            vc.selectedUserId = user.uuid
            vc.selectedColor = cell.backgroundColor                    
        } else if segue.identifier == "addUserSegue" {
            var popupSegue : CCMPopupSegue = segue as CCMPopupSegue
            if self.view.bounds.size.height < 420 {
                popupSegue.destinationBounds = CGRectMake(0, 0, ((UIScreen.mainScreen().bounds.size.height-20) * 0.75), (UIScreen.mainScreen().bounds.size.height-20))
            } else {
                popupSegue.destinationBounds = CGRectMake(0, 0, 650, 350)
            }
            popupSegue.backgroundBlurRadius = 7
            popupSegue.backgroundViewAlpha = 0.9
            popupSegue.backgroundViewColor = UIColor.paperColorGray400()
            popupSegue.dismissableByTouchingBackground = true
            self.popupController = popupSegue.destinationViewController as? AddUserController

        }
    }


    @IBAction func toggleEditMode(sender: UIBarButtonItem) {
        if isEditing == false {
            isEditing = true
            sender.tintColor = UIColor.paperColorRed()
        } else {
            isEditing = false
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
                    self.isEditing = false
                    self.editButton.tintColor = UIColor.paperColorBlue400()
                    } , completion: nil)
                
                SweetAlert().showAlert("Deleted!", subTitle: "", style: AlertStyle.Success)
            }
        }
        
        
       

    }
    
    
    @IBAction func popoverCancelButton(segue:UIStoryboardSegue) {
        var addController = segue.sourceViewController as AddUserController
        addController.dismissAnimated()
    }
    
    @IBAction func popoverAddButton(segue:UIStoryboardSegue) {
        
        
        
        var addController = segue.sourceViewController as AddUserController
        
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
                
                
                Async.background {
                    var message = PosterMessage()
                    message.type = "user"
                    message.action = "add"
                    let JSONString = Mapper().toJSONString(newUser, prettyPrint: false)
                    message.content = JSONString
                    
                    let JSONSMessage = Mapper().toJSONString(message, prettyPrint: false)
                    
                    MQTTPipe.sharedInstance.sendMessage(JSONSMessage)
                    
                }.background {
                        DBHelper.sharedMonitor().createPoster(newPoster)
                }
                
 

            }
            
                    
        })
        
    }

    
    
    @IBAction func onBurger() {
        (tabBarController as TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
   
    
}

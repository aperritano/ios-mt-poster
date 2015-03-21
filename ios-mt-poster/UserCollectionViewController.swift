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

class UserCollectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var nameLabels : [String] = ["GROUP 1", "GROUP 2", "GROUP 3","GROUP 4","GROUP 5","GROUP 6","GROUP 7","GROUP 8","GROUP 8"]
    
    @IBOutlet var collectionView: UICollectionView!
    
    var isEditing = false
    
    var colors: [UIColor] = [UIColor.paperColorRed400(), UIColor.paperColorIndigo400(), UIColor.paperColorPink400(), UIColor.paperColorLightBlue400(), UIColor.paperColorAmber400(), UIColor.paperColorOrange400(), UIColor.paperColorBrown400(), UIColor.paperColorTeal400(), UIColor.paperColorPink400(), UIColor.paperColorBlue400(), UIColor.paperColorGray400(), UIColor.paperColorDeepPurple400(), UIColor.paperColorGreen400()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)

        SwiftEventBus.onMainThread(self, name: "DBReloadedEvent") { _ in
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
            vc.selectedUserId = user.id
            vc.selectedColor = cell.backgroundColor                    
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

        SweetAlert().showAlert("Are you sure?", subTitle: "This user and all of its posters will be permanently delete!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColor.paperColorBlue400() , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColor.paperColorRed()) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                println("Cancel Button  Pressed")
            }
            else {
                
                self.collectionView.performBatchUpdates({
                    DBHelper.sharedMonitor().deleteUser(sender.tag)
                    var path = NSIndexPath(forRow: sender.tag, inSection: 0)
                    self.collectionView.deleteItemsAtIndexPaths([path])
                    } , completion: nil)
                
                SweetAlert().showAlert("Deleted!", subTitle: "This user has been deleted!", style: AlertStyle.Success)
            }
        }
        
        
       

    }
    @IBAction func addUserAction(sender: UIBarButtonItem) {
        
        println("add user action")
        var newUser = User()
        newUser.uid = NSUUID().UUIDString
        newUser.name = "BESTIES"
        newUser.nameTags = ["bob", "lop"]
        newUser.posters = []
     
        let JSONString = Mapper().toJSONString(newUser, prettyPrint: false)
        println("User: \(JSONString)")


        DBHelper.sharedMonitor().postJSON(JSONString, postType: "user")
        
        
        
    }
    
    @IBAction func onBurger() {
        (tabBarController as TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
   
    
}

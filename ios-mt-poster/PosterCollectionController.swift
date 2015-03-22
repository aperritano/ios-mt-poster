//
//  PosterCollectionController.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/14/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus
import CCMPopup
import Async

class PosterCollectionController :UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    var nameLabels : [String] = ["GROUP 1", "GROUP 2", "GROUP 3","GROUP 4","GROUP 5","GROUP 6","GROUP 7","GROUP 8","GROUP 8"]
    var selectedColor: UIColor?
    var selectedUserId: String?
    var isEditing = false
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!

    var popupController: AddPosterController?

    
    var colors: [UIColor] = [UIColor.paperColorRed400(), UIColor.paperColorIndigo400(), UIColor.paperColorLime400(), UIColor.paperColorLightBlue400(), UIColor.paperColorAmber400(), UIColor.paperColorOrange400(), UIColor.paperColorBrown400(), UIColor.paperColorTeal400(), UIColor.paperColorPink400(), UIColor.paperColorBlue400(), UIColor.paperColorGray400(), UIColor.paperColorDeepPurple400(), UIColor.paperColorGreen400()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadWithDBHelper()
        
        UINavigationBar.appearance().barTintColor = UIColor.paperColorGray600()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        SwiftEventBus.onMainThread(self, name: "PosterReloadedEvent") { _ in
            self.reloadWithDBHelper()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func reloadWithDBHelper() {
        if let uid = selectedUserId {
            self.collectionView?.reloadData()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DBHelper.sharedMonitor().fetchPostersWithUser(selectedUserId!).count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "posterItemSegue"{
            let vc = segue.destinationViewController as PosterItemCollectionController
            let cell = sender as UserCell
            let poster = DBHelper.sharedMonitor().fetchPostersWithUser(selectedUserId!).filter({ $0.name == cell.title.text }).first!
            vc.selectedPosterId = poster.uuid
            vc.selectedColor = cell.backgroundColor
        } else if segue.identifier == "addPosterSegue" {
            var popupSegue : CCMPopupSegue = segue as CCMPopupSegue
            if self.view.bounds.size.height < 420 {
                popupSegue.destinationBounds = CGRectMake(0, 0, ((UIScreen.mainScreen().bounds.size.height-20) * 0.75), (UIScreen.mainScreen().bounds.size.height-20))
            } else {
                popupSegue.destinationBounds = CGRectMake(0, 0, 650, 250)
            }
            popupSegue.backgroundBlurRadius = 7
            popupSegue.backgroundViewAlpha = 0.9
            popupSegue.backgroundViewColor = UIColor.paperColorGray400()
            popupSegue.dismissableByTouchingBackground = true
            self.popupController = popupSegue.destinationViewController as? AddPosterController
            
        }

    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UserCell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath: indexPath) as UserCell
        let color = UIColor.paperColorTeal400()
        var poster = DBHelper.sharedMonitor().fetchPostersWithUser(selectedUserId!)[indexPath.row]
        cell.title.text = poster.name
        cell.removeButton.tag = indexPath.row
        cell.removeButton.hidden = !isEditing
        cell.backgroundColor = color
        return cell
        
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
        
        SweetAlert().showAlert("Are you sure?", subTitle: "This POSTER and all of its POSTER ITEMS will be permanently deleted!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColor.paperColorBlue400() , otherButtonTitle:  "YES", otherButtonColor: UIColor.paperColorRed()) { (isOtherButton) -> Void in
            if isOtherButton == true {
                println("Cancel Button  Pressed")
            } else {
                
                
                var indexPath : NSIndexPath = self.collectionView.indexPathForItemAtPoint(self.collectionView.convertPoint(sender.center, fromView: sender.superview))!
                

                    var posterId : String?
                    var posters = DBHelper.sharedMonitor().fetchPostersWithUser(self.selectedUserId!)
                    var selectedPoster = posters[indexPath.row]
                    posterId = selectedPoster.uuid!
                    Async.background{
                        var selectedUser = DBHelper.sharedMonitor().fetchUser(self.selectedUserId!)
                        var localPosters = selectedUser?.posters as [String]!
                        if let index = find(localPosters, posterId!) {
                            selectedUser?.posters?.removeAtIndex(index)
                            DBHelper.sharedMonitor().updateUser(selectedUser!)                        
                        }
                        
                        DBHelper.sharedMonitor().deletePoster(selectedPoster)
                    }.main{
                        self.collectionView.deleteItemsAtIndexPaths([indexPath])
                        self.collectionView.reloadData()
                        self.isEditing = false
                        self.editButton.tintColor = UIColor.paperColorBlue400()
                        SweetAlert().showAlert("Deleted!", subTitle: "", style: AlertStyle.Success)
                    }
                }
                
            
        }
        
        
        
        
    }

    
    
    @IBAction func popoverCancelButton(segue:UIStoryboardSegue) {
        var addController = segue.sourceViewController as AddPosterController
        addController.dismissAnimated()
    }
    
    @IBAction func popoverAddButton(segue:UIStoryboardSegue) {
        var addController = segue.sourceViewController as AddPosterController
        
        addController.dismissViewControllerAnimated(true, completion: {
            

            var posterName = addController.posterNameTextField.text
            
            if !posterName.isEmpty {
                
                var newPoster =  Poster()
                
                
                newPoster.name = posterName                                
                newPoster.uuid = NSUUID().UUIDString
                newPoster.height = 1583
                newPoster.width = 2876
                newPoster.posterItems = []
                
                Async.background {
                    var selectedUser = DBHelper.sharedMonitor().fetchUser(self.selectedUserId!)
                    selectedUser?.posters?.append(newPoster.uuid!)
                    DBHelper.sharedMonitor().updateUser(selectedUser!)
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

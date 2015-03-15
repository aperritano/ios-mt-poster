//
//  PosterItemCollectionController.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/14/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation


import Foundation

class PosterItemCollectionController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var posterItems: [PosterItem] = [PosterItem]()

    @IBOutlet var collectionView: UICollectionView!
    
    var nameLabels : [String] = ["GROUP 1", "GROUP 2", "GROUP 3","GROUP 4","GROUP 5","GROUP 6","GROUP 7","GROUP 8","GROUP 8"]
    var selectedColor: UIColor?
    var selectedPoster: String?
    
    var colors: [UIColor] = [UIColor.paperColorRed400(), UIColor.paperColorIndigo400(), UIColor.paperColorLime400(), UIColor.paperColorLightBlue400(), UIColor.paperColorAmber400(), UIColor.paperColorOrange400(), UIColor.paperColorBrown400(), UIColor.paperColorTeal400(), UIColor.paperColorPink400(), UIColor.paperColorBlue400(), UIColor.paperColorGray400(), UIColor.paperColorDeepPurple400(), UIColor.paperColorGreen400()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        UINavigationBar.appearance().barTintColor = selectedColor
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posterItems.count
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
                var cell = collectionView.cellForItemAtIndexPath(indexPath)
                cell?.contentView.backgroundColor = UIColor.paperColorGray900()

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor.paperColorYellow400()
    }
    
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) -> Bool {
        
        return true
    }

    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
        //
    }
    
//    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
//        var cell = collectionView.cellForItemAtIndexPath(indexPath)
//        cell?.contentView.backgroundColor = UIColor.paperColorGray900()
//    }
//    
//    
//    
//    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
//        var cell = collectionView.cellForItemAtIndexPath(indexPath)
//        cell?.contentView.backgroundColor = nil
//    }
    
    var popupController: AddPosterItemController?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        CCMPopupSegue *popupSegue = (CCMPopupSegue *)segue;
//        if (self.view.bounds.size.height < 420) {
//            popupSegue.destinationBounds = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.height-20) * .75, [UIScreen mainScreen].bounds.size.height-20);
//        } else {
//            popupSegue.destinationBounds = CGRectMake(0, 0, 300, 400);
//        }
//        popupSegue.backgroundBlurRadius = 7;
//        popupSegue.backgroundViewAlpha = 0.3;
//        popupSegue.backgroundViewColor = [UIColor blackColor];
//        popupSegue.dismissableByTouchingBackground = YES;
//        self.popupController = popupSegue.destinationViewController;
        var popupSegue : CCMPopupSegue = segue as CCMPopupSegue
        if self.view.bounds.size.height < 420 {
            popupSegue.destinationBounds = CGRectMake(0, 0, ((UIScreen.mainScreen().bounds.size.height-20) * 0.75), (UIScreen.mainScreen().bounds.size.height-20))
        } else {
            popupSegue.destinationBounds = CGRectMake(0, 0, 800, 700)
        }
            popupSegue.backgroundBlurRadius = 7
            popupSegue.backgroundViewAlpha = 0.9
            popupSegue.backgroundViewColor = UIColor.paperColorGray400()
            popupSegue.dismissableByTouchingBackground = true
            self.popupController = popupSegue.destinationViewController as AddPosterItemController

        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.view.layoutIfNeeded()
//        if (size.height < 420) {
//            [UIView animateWithDuration:[coordinator transitionDuration] animations:^{
//                self.popupController.view.bounds = CGRectMake(0, 0, (size.height-20) * .75, size.height-20);
//                [self.view layoutIfNeeded];
//                }];
//        } else {
        
        UIView.animateWithDuration(coordinator.transitionDuration(), animations: {
            self.popupController?.view.bounds = CGRectMake(0, 0, 800, 700)
            self.view.layoutIfNeeded()
        
        })
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : PosterItemCell = collectionView.dequeueReusableCellWithReuseIdentifier("PosterItemCell", forIndexPath: indexPath) as PosterItemCell
        let color = UIColor.paperColorBlue400()
        let posterItem = posterItems[indexPath.row]
        
        

        cell.title.text = posterItems[indexPath.row].name
        
        let decodedData = NSData(base64EncodedString: posterItem.image_bytes!, options: NSDataBase64DecodingOptions(0))

        var decodedimage = UIImage(data: decodedData!)
        cell.posterImage.image = decodedimage as UIImage!
        
        cell.backgroundColor = color
        return cell
        
    }
    
    
    
    @IBAction func popoverCancelButton(segue:UIStoryboardSegue) {
    }
    
    @IBAction func popoverAddButton(segue:UIStoryboardSegue) {
  
        
        
        
        
            var posterItemController = segue.sourceViewController as AddPosterItemController
            
            
            
        
            
        posterItemController.dismissViewControllerAnimated(true, completion: {
            
            var imageData = UIImagePNGRepresentation(posterItemController.posterImageView.image)
            let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
            
            
            
            var posterItem  = PosterItem()
            posterItem.id = NSUUID().UUIDString
            posterItem.x = 500
            posterItem.y = 500
            posterItem.width = 500
            posterItem.height = 500
            
            if let message = posterItemController.messageTextField.text {
                posterItem.name = message
            } else {
                posterItem.name = "poster-image-5"
            }
            
            
            posterItem.image_bytes = base64String
            posterItem.image_id = "png"
            
            
            self.posterItems.append(posterItem)
            
                        self.collectionView.reloadData()
        
        })



        
        

        
    }
    
    
    @IBAction func deleteAction(sender: AnyObject) {
        
        self.collectionView.performBatchUpdates({
            
            var indexPaths = self.collectionView.indexPathsForSelectedItems()
            
            var trash: [PosterItem] = [PosterItem]()
            
            for path in indexPaths {
                trash.append(self.posterItems[path.row])
                
                self.posterItems.removeAtIndex(path.row)
            }
            

            
            self.collectionView.deleteItemsAtIndexPaths(indexPaths)
            }, completion: nil)
        
    }
    
    @IBAction func editAction(sender: UIBarButtonItem) {
    }
    @IBAction func onBurger() {
        (tabBarController as TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
}

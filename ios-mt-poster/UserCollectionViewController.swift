//
//  UserCollectionViewController.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/14/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation


class UserCollectionViewController : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var nameLabels : [String] = ["GROUP 1", "GROUP 2", "GROUP 3","GROUP 4","GROUP 5","GROUP 6","GROUP 7","GROUP 8","GROUP 8"]
    
    var colors: [UIColor] = [UIColor.paperColorRed400(), UIColor.paperColorIndigo400(), UIColor.paperColorLime400(), UIColor.paperColorLightBlue400(), UIColor.paperColorAmber400(), UIColor.paperColorOrange400(), UIColor.paperColorBrown400(), UIColor.paperColorTeal400(), UIColor.paperColorPink400(), UIColor.paperColorBlue400(), UIColor.paperColorGray400(), UIColor.paperColorDeepPurple400(), UIColor.paperColorGreen400()]
    
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
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DBHelper.sharedMonitor().users.count
    }
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
         return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {                    
        var cell : UserCell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath: indexPath) as UserCell
        let color = colors[indexPath.row]
        cell.title.text = DBHelper.sharedMonitor().users[indexPath.row].name
        cell.backgroundColor = color
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "posterSegue"{
            let vc = segue.destinationViewController as PosterCollectionController
            let cell = sender as UserCell
            let user = DBHelper.sharedMonitor().users.filter(){ $0.name == cell.title.text }.first!
            
            vc.posters = user.posters
            vc.selectedUser = cell.title.text
            vc.selectedColor = cell.backgroundColor                    
        }
    }
    
    @IBAction func onBurger() {
        (tabBarController as TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
   
    
}

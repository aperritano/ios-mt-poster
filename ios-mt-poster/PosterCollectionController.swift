//
//  PosterCollectionController.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/14/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation

class PosterCollectionController : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var posters: [Poster] = [Poster]()
    
    var nameLabels : [String] = ["GROUP 1", "GROUP 2", "GROUP 3","GROUP 4","GROUP 5","GROUP 6","GROUP 7","GROUP 8","GROUP 8"]
    var selectedColor: UIColor?
    var selectedUser: String?
    
    var colors: [UIColor] = [UIColor.paperColorRed400(), UIColor.paperColorIndigo400(), UIColor.paperColorLime400(), UIColor.paperColorLightBlue400(), UIColor.paperColorAmber400(), UIColor.paperColorOrange400(), UIColor.paperColorBrown400(), UIColor.paperColorTeal400(), UIColor.paperColorPink400(), UIColor.paperColorBlue400(), UIColor.paperColorGray400(), UIColor.paperColorDeepPurple400(), UIColor.paperColorGreen400()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = selectedColor
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "posterItemSegue"{
            let vc = segue.destinationViewController as PosterItemCollectionController
            let cell = sender as UserCell
            let poster = posters.filter({ $0.name == cell.title.text }).first!
            
            vc.posterItems = poster.posterItems
            vc.selectedPoster = cell.title.text
            vc.selectedColor = cell.backgroundColor
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UserCell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath: indexPath) as UserCell
        let color = UIColor.paperColorTeal400()
        cell.title.text = posters[indexPath.row].name
        cell.backgroundColor = color
        return cell
        
    }
    
    @IBAction func onBurger() {
        (tabBarController as TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
}

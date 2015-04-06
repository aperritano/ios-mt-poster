//
//  UserCell.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/14/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation
import BFPaperCollectionViewCell

class UserCell : BFPaperCollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var nameTags: UILabel!
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var removeButton: MKButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func DeleteAction(sender: MKButton) {
        println("IM A Delete")
    }
  
    
}
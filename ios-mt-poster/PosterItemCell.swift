//
//  PosterItemCell.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 3/14/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import Foundation

class PosterItemCell :  BFPaperCollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    
}
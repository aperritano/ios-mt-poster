//
//  BallUIView.swift
//  
//
//  Created by Anthony Perritano on 2/28/15.
//
//

import Foundation
import UIKit

class BallUIView: UIView {

    var baseColor: UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        baseColor = UIColor.redColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        // CircleStyleKit.drawCircleCanvas(mainColor: baseColor!, ovalcenter: CGPointMake(500, 500));
    }
}
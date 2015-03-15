// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

public class CircleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func drawRect(rect: CGRect) {


        let circleWidth: CGFloat = 100.0

//// General Declarations
        let context = UIGraphicsGetCurrentContext()

//// Color Declarations
        let color = UIColor(red: 0.815, green: 0.091, blue: 0.091, alpha: 1.000)

//// Shadow Declarations
        let shadow = UIColor.darkGrayColor()
        let shadowOffset = CGSizeMake(0.1, -0.1)
        let shadowBlurRadius: CGFloat = 3

//// Oval Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 20, -39)

        var ovalPath = UIBezierPath(ovalInRect: CGRectMake(0, 88.5, circleWidth, circleWidth))
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, (shadow as UIColor).CGColor)
        color.setFill()
        ovalPath.fill()
        CGContextRestoreGState(context)

        UIColor.blackColor().setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()

        CGContextRestoreGState(context)
    }
}

var view = CircleView(frame: CGRectMake(0, 0, 100, 100))
view.setNeedsLayout()

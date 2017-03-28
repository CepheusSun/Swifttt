//
//  HeartFlayView.swift
//  Live
//
//  Created by sunny on 2017/3/21.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit

class HeartFlayView: UIView {

    var strokeColor: UIColor!
    var fillColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        strokeColor = UIColor.white
        fillColor = UIColor.randomColor()
        self.backgroundColor = UIColor.clear
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func animate(in view:UIView) {
        let totalAnimationDuration: CGFloat = 6.0
        let heartSize: CGFloat = self.bounds.width
        let heartCenterX: CGFloat = self.center.x
        let viewHeight: CGFloat = view.bounds.height
        
        // Pre-Animation setup
        transform = CGAffineTransform(scaleX: 0, y: 0)
        alpha = 0
        
        // Bloom
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.identity
            self.alpha = 0.9
        }, completion: nil)
        
        let i = Int(arc4random_uniform(2))
        let rotationDirection = 1 - 2 * i // -1 OR 1
        let rotationFraction = arc4random_uniform(10)
        
        UIView.animate(withDuration: TimeInterval(totalAnimationDuration)) { 
            self.transform = CGAffineTransform(rotationAngle: CGFloat(rotationDirection) * CGFloat.pi / (CGFloat(16) + CGFloat(rotationFraction) + CGFloat(0.2)))
        }
        
        let heartTravelPath = UIBezierPath()
        heartTravelPath.move(to: self.center)
        
        // random end point
        let endPoint = CGPoint(x: heartCenterX + CGFloat(rotationDirection * Int(arc4random_uniform(UInt32(2*heartSize)))),
                               y: viewHeight / 6.0 + CGFloat(arc4random_uniform(UInt32(viewHeight / 4))))
        
        // random Control Points
        let j = Int(arc4random_uniform(2))
        let travelDirection = 1 - 2 * j  // -1 OR 1
        
        // randomize x and y for control points
        let xDelta = (heartSize/2.0 + CGFloat(arc4random_uniform(UInt32(2*heartSize)))) * CGFloat(travelDirection)
        
        let flag = CGFloat(arc4random_uniform(UInt32(8.0) * UInt32(heartSize)))
        var flag2 = heartSize
        if flag > heartSize {
            flag2 = flag
        }
        var yDelta = endPoint.y
        if endPoint.y < flag2 {
            yDelta = flag2
        }
        let controlPoint = CGPoint(x: heartCenterX + xDelta, y: viewHeight - yDelta)
        let controlPoint2 = CGPoint(x: heartCenterX - 2 * xDelta, y: yDelta)
        
        
        heartTravelPath.addCurve(to: endPoint, controlPoint1: controlPoint, controlPoint2: controlPoint2)
        
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.path = heartTravelPath.cgPath
        keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        keyFrameAnimation.duration = CFTimeInterval(totalAnimationDuration + endPoint.y / viewHeight)
        self.layer.add(keyFrameAnimation, forKey: "positionOnPath")
        
        // Alpha & remove from superView
        UIView.animate(withDuration: TimeInterval(totalAnimationDuration), animations: { 
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        self.drawHeartInRect(rect: rect)
    }
    
    
    func drawHeartInRect(rect: CGRect!) {
        
        strokeColor.setStroke()
        fillColor.setFill()
        
        let drawingPadding: CGFloat = 4.0
        let curveRadius = floor((rect.width - 2 * drawingPadding) / 4.0)
        
        // creat path
        let heartPath = UIBezierPath()
        
        // start at bottom heart tip
        let tipLocation = CGPoint(x: floor(rect.width) / 2,
                                  y: rect.height - drawingPadding)
        heartPath.move(to: tipLocation)
        
        // move to top left start of curve
        let topLeftCurveStart = CGPoint(x: drawingPadding,
                                        y: floor(rect.height) / 2.4)
        
        heartPath.addQuadCurve(to: topLeftCurveStart,
                    controlPoint: CGPoint(x: topLeftCurveStart.x,
                                          y: topLeftCurveStart.y + curveRadius))
        
        // create top left curve
        heartPath.addArc(withCenter: CGPoint(x: topLeftCurveStart.x + curveRadius,
                                             y: topLeftCurveStart.y),
                         radius: curveRadius,
                         startAngle: CGFloat.pi,
                         endAngle: 0,
                         clockwise: true)
        
        // create top right curve
        let topRightCurveStart = CGPoint(x: topLeftCurveStart.x + 2 * curveRadius,
                                         y: topLeftCurveStart.y)
        
        heartPath.addArc(withCenter: CGPoint(x: topRightCurveStart.x + curveRadius,
                                             y: topRightCurveStart.y),
                         radius: curveRadius,
                     startAngle: CGFloat.pi,
                     endAngle: 0,
                     clockwise: true)

        // final curve to bottom heart tip
        let topRightCurveEnd = CGPoint(x: topLeftCurveStart.x + 4 * curveRadius,
                                       y: topRightCurveStart.y)
        heartPath.addQuadCurve(to: tipLocation,
                               controlPoint: CGPoint(x: topRightCurveEnd.x,
                                                     y: topRightCurveEnd.y + curveRadius))
        
        heartPath.fill()
        heartPath.lineCapStyle = .round
        heartPath.lineJoinStyle = .round
        heartPath.stroke()
        
    }

}

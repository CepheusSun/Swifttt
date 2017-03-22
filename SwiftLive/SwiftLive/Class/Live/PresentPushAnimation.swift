//
//  PresentPushAnimation.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/22.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit

class PresentPushAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    // 指定转场动画持续的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(0.5)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let containeView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let transitionDuration = self.transitionDuration(using: transitionContext) as TimeInterval
        
        let frame = UIScreen.main.bounds
        let isPresent = toVC?.presentingViewController == fromVC
        if isPresent {
            fromView?.frame = frame
            toView?.frame = frame.offsetBy(dx: UIScreen.main.bounds.width, dy: 0)
            containeView.addSubview(toView!)
        } else {
            fromView?.frame = frame
            toView?.frame = frame.offsetBy(dx: UIScreen.main.bounds.width * -1, dy: 0)
            containeView.addSubview(toView!)
        }
        UIView.animate(withDuration: transitionDuration, animations: {
            if isPresent {
                toView?.frame = frame
                fromView?.frame = frame.offsetBy(dx: UIScreen.main.bounds.width * -1, dy: 0)
            } else {
                toView?.frame = frame
                fromView?.frame = frame.offsetBy(dx: UIScreen.main.bounds.width, dy: 0)
            }
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}

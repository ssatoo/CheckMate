//
//  TransitionToLeft.swift
//  CheckMate
//
//  Created by Zacharias Giakoumi on 05/05/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class TransitionToLeft: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView:UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView:UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        transitionContext.containerView().addSubview(fromView)
        transitionContext.containerView().addSubview(toView)
        
        toView.frame = CGRectMake(toView.frame.width, 0, toView.frame.width, toView.frame.height)
        let fromNewFrame = CGRectMake(-1 * fromView.frame.width, 0, fromView.frame.width, fromView.frame.height)
        
        UIView.animateWithDuration( 0.7, animations:{ () -> Void in
            toView.frame = fromView.frame
            fromView.frame = fromNewFrame
            },{ (Bool) -> Void in
                // update internal view - must always be called
                transitionContext.completeTransition(true)
        })
        
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.7
    }
    
}
//
//  PopAnimator.swift
//  iGenFamilyTree
//
//  Created by ben smith on 20/06/17.
//  Copyright © 2017 ben smith. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    
    let duration = 0.6
    var presenting = true
    var originFrame = CGRect(x: 20, y: 20, width: 0, height: 0)
    var dismissCompletion: (()->Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 1) containerView is where your animations will live
        // 2) toView is the new view to present
        // 3) herbView is just the toView; otherwise it will be fetched from the context. 
        //    For both presenting and dismissing, herbView will always be the view that you animate.
        
        let containerView = transitionContext.containerView // 1)
        
//        var toViewNilBug = toView==nil;
//        if (!toView) { // Workaround by getting it from the view.
//            toView = toVC.view;
//        }
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let hasViewForKey = transitionContext.responds(to: #selector(UIViewControllerTransitionCoordinatorContext.view(forKey:)))
        var toView = hasViewForKey ? transitionContext.view(forKey: UITransitionContextViewKey.to) : toVC?.view
        if toView == nil {
            toView = toVC?.view;
        }

        //before
//        let containerView = transitionContext.containerView // 1)
//        let toView = transitionContext.view(forKey: .to)!   // 2)
//        let humanView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        if let humanView = presenting ? toView : transitionContext.view(forKey: .from) {
        
            let initialFrame = presenting ? originFrame : humanView.frame
            let finalFrame = presenting ? humanView.frame : originFrame
            
            let xScaleFactor = presenting ?
                
                initialFrame.width / finalFrame.width :
                finalFrame.width / initialFrame.width
            
            let yScaleFactor = presenting ?
                
                initialFrame.height / finalFrame.height :
                finalFrame.height / initialFrame.height
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                                   y: yScaleFactor)
            
            if presenting {
                humanView.transform = scaleTransform
                humanView.center = CGPoint(
                    x: initialFrame.midX,
                    y: initialFrame.midY)
                humanView.clipsToBounds = true

            }
            containerView.addSubview(toView!)
            containerView.bringSubview(toFront: humanView)
            
            UIView.animate(withDuration: duration, delay:0.0,
                           usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0,
                           animations: {
                            humanView.transform = self.presenting ?
                                CGAffineTransform.identity : scaleTransform
                            humanView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }, 
                           completion:{_ in
                            if !self.presenting {
                                self.dismissCompletion?()
                            }
                            transitionContext.completeTransition(true)
            })
        }
    }
        
        
        /*
        containerView.addSubview(toView)
        toView.alpha = 0.0
        UIView.animate(withDuration: duration,
                       animations: {
                        toView.alpha = 1.0
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        })*/
        
    
    
}

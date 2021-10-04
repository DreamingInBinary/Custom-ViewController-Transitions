//
//  TransitionAnimator.swift
//  Custom Transitions
//
//  Created by Jordan Morgan on 9/30/21.
//

import Foundation
import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var transitionDuration: TimeInterval = 1.0
    var isPresenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Views and controllers
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        // Rects
        let containerFrame: CGRect = containerView.frame
        var toViewBeginningFrame: CGRect = .zero
        var toViewEndingFrame: CGRect = .zero
        var fromViewEndingFrame: CGRect = .zero
        
        if let destinationView = toView, let presentedVC = toVC, let presentingVC = fromVC {
            containerView.addSubview(destinationView)
            toViewBeginningFrame = transitionContext.initialFrame(for: presentedVC)
            toViewEndingFrame = transitionContext.finalFrame(for: presentedVC)
            fromViewEndingFrame = transitionContext.finalFrame(for: presentingVC)
        }
        
        if isPresenting {
            toViewBeginningFrame.origin = CGPoint(x: containerFrame.size.width, y: containerFrame.size.width)
            toViewBeginningFrame.size = toViewEndingFrame.size
        } else {
            fromViewEndingFrame = CGRect(x:containerFrame.size.width,
                                         y:containerFrame.size.height,
                                         width:toView?.frame.size.width ?? 0,
                                         height:toView?.frame.size.height ?? 0);
        }
        
        toView?.frame = toViewBeginningFrame
        
        // For interactive animations, you might want to avoid nonlinear effects in the animations themselves. These usually decouple the touch location of events.
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseOut) {
            if self.isPresenting {
                toView?.frame = toViewEndingFrame
                fromVC?.view.frame = containerFrame
            } else {
                fromView?.frame = fromViewEndingFrame
            }
        } completion: { done in
            let succeeded = !transitionContext.transitionWasCancelled
            let failedPresenting = (self.isPresenting && !succeeded)
            let didDismiss = (!self.isPresenting && succeeded)
            
            if (failedPresenting || didDismiss) {
                toView?.removeFromSuperview()
            }
            
            transitionContext.completeTransition(succeeded)
        }

    }
}

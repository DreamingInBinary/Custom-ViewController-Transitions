//
//  TransitionPresentationController.swift
//  Custom Transitions
//
//  Created by Jordan Morgan on 9/30/21.
//

import UIKit

class TransitionPresentationController: UIPresentationController {
    var transitioningDelegateWantsInteractiveDismissal: Bool = false
    private var dimmingView: UIView = UIView(frame: .zero)
    private var panGesture: UIPanGestureRecognizer? = nil
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        dimmingView.alpha = 0.0
    }
    
    // MARK: Chrome Animations
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView else { return }
        
        dimmingView.frame = container.bounds
        dimmingView.alpha = 0.0
        container.insertSubview(dimmingView, at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.dimmingView.alpha = 1.0
        }, completion: { [weak self] context in
            if context.isCancelled {
                self?.dimmingView.alpha = 0.0
            }
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard let container = containerView,
        transitioningDelegateWantsInteractiveDismissal == true,
        let _ = presentedViewController.transitioningDelegate as? TransitionDelegate else { return }
        
        // Attach a gesture recognizer to the dimming view to allow for a swipe to dismiss
        // Once we've confirmed that our transition delegate wants one
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeToDismiss(pan:)))
        panGesture?.maximumNumberOfTouches = 1
        container.addGestureRecognizer(panGesture!)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        
        coordinator.animate { [weak self] context in
            self?.dimmingView.alpha = 0.0
        } completion: { [weak self] context in
            if context.isCancelled {
                self?.dimmingView.alpha = 1.0
            }
        }

    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    // MARK: Sizing
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        guard let containerBounds = containerView?.bounds else { return .zero }
        
        presentedViewFrame.size = CGSize(width: (containerBounds.size.width/2), height: containerBounds.size.height)
        presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width;
        return presentedViewFrame;
    }
    
    // MARK: Private
    
    @objc private func handleSwipeToDismiss(pan:UIPanGestureRecognizer) {
        guard let container = containerView,
              let customTransitionDelegate = presentedViewController.transitioningDelegate as? TransitionDelegate else { return }
        
        let percentDriver = customTransitionDelegate.interactiveAnimator
        let translation = pan.translation(in: container)
        let percentComplete = abs(translation.y/container.bounds.height)
        let completionThreshold = percentComplete * 0.80
        
        func bailOut(withCancel: Bool) {
            if withCancel {
                percentDriver.cancel()
            } else {
                percentDriver.finish()
                container.removeGestureRecognizer(pan)
            }
        }
        
        switch pan.state {
        case .began:
            pan.setTranslation(.zero, in: container)
            presentedViewController.dismiss(animated: true) // Kicks off interactive transition
        case .changed:
            percentDriver.update(percentComplete)
        case .ended:
            if completionThreshold > 0.5 || pan.velocity(in: container).y > 0 {
                percentDriver.completionSpeed = 1.0
                bailOut(withCancel: false)
            } else {
                // Smooth out cancellation
                percentDriver.completionSpeed = 1.0 * percentComplete
                bailOut(withCancel: true)
            }
        case .cancelled:
            bailOut(withCancel: true)
        case .failed:
            bailOut(withCancel: false)
        default:
            bailOut(withCancel: false)
        }
    }
}

//
//  TransitionDelegate.swift
//  Custom Transitions
//
//  Created by Jordan Morgan on 9/30/21.
//

import Foundation
import UIKit

enum UseCase {
    case justAnimator
    case justPresentationController
    case animatorAndPresentationController
    case interactiveAnimatorAndPresentationController
}

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var demoedUseCase: UseCase = .justAnimator
    let interactiveAnimator: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
    
    // MARK: Animators. Sometimes called animation controllers.
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return createAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return createAnimator(isPresenting: false)
    }
    
    // MARK: Interactive animators. Sometimes called interactive animation controllers.
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard demoedUseCase == .interactiveAnimatorAndPresentationController else { return nil }
        return interactiveAnimator
    }
    
    // MARK: Presentation Controllers
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch demoedUseCase {
        case .justAnimator:
            return nil
        case .justPresentationController:
            return TransitionPresentationController(presentedViewController: presented, presenting: presenting)
        case .animatorAndPresentationController:
            return TransitionPresentationController(presentedViewController: presented, presenting: presenting)
        case .interactiveAnimatorAndPresentationController:
            let presentationController = TransitionPresentationController(presentedViewController: presented, presenting: presenting)
            presentationController.transitioningDelegateWantsInteractiveDismissal = true
            
            return presentationController
        }
    }
    
    // MARK: Private
    
    private func createAnimator(isPresenting:Bool) -> UIViewControllerAnimatedTransitioning? {
        let animator = TransitionAnimator()
        animator.isPresenting = isPresenting
        
        switch demoedUseCase {
        case .justAnimator, .animatorAndPresentationController:
            return animator
        case .justPresentationController:
            return nil
        case .interactiveAnimatorAndPresentationController:
            return animator
        }
    }
}

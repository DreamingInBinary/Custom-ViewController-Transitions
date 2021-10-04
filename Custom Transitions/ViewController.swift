//
//  ViewController.swift
//  Custom Transitions
//
//  Created by Jordan Morgan on 9/30/21.
//

import UIKit

class ViewController: UIViewController {
    let customTransitionDelegate: TransitionDelegate = TransitionDelegate()
    let tv = UITableView(frame: .zero, style: .insetGrouped)
    lazy var datasource = Source(tableView: tv, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    // MARK: Custom animation options
    
    func hookIntoExistingCoordinator() {
        // This doesn't use any custom transition. It simply hooks into the
        // Ones already occuring.
        let vc = createDemoController()
        present(vc, animated: true, completion: nil)
        
        transitionCoordinator?.animate(alongsideTransition: { context in
            self.tv.backgroundColor = .red
        }, completion: { context in
            if context.isCancelled {
                self.tv.backgroundColor = .systemGroupedBackground
            } else {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut) {
                    self.tv.backgroundColor = .systemGroupedBackground
                } completion: { finished in
                    
                }
            }
        })
    }
    
    func onlyUseCustomAnimator() {
        customTransitionDelegate.demoedUseCase = .justAnimator
        
        let vc = createDemoController()
        vc.transitioningDelegate = customTransitionDelegate
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func onlyPresentationController() {
        customTransitionDelegate.demoedUseCase = .justPresentationController
        
        let vc = createDemoController()
        vc.transitioningDelegate = customTransitionDelegate
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
    func animatorAndPresentationController() {
        customTransitionDelegate.demoedUseCase = .animatorAndPresentationController
        
        let vc = createDemoController()
        vc.transitioningDelegate = customTransitionDelegate
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
    func interactiveAnimatorAndPresentationController() {
        customTransitionDelegate.demoedUseCase = .interactiveAnimatorAndPresentationController
        
        let vc = createDemoController()
        vc.transitioningDelegate = customTransitionDelegate
        vc.modalPresentationStyle = .custom
        vc.view.subviews.forEach { $0.removeFromSuperview() }
        present(vc, animated: true, completion: nil)
    }
}


//
//  ControllerSetup.swift
//  Custom Transitions
//
//  Created by Jordan Morgan on 10/1/21.
//

import Foundation
import UIKit

typealias TableDataSource = UITableViewDiffableDataSource<Int, PresentationScenario>

class Source: TableDataSource {
    override func tableView(_ tableView: UITableView, titleForFooterInSection
                                section: Int) -> String? {
        return PresentationScenario.all[section].info
    }
}

extension ViewController {
    func createDemoController() -> UIViewController {
        let demoVC = UIViewController()
        let demoView = demoVC.view!
        demoView.backgroundColor = .blue
        
        let dismiss = UIButton(configuration: .borderedProminent(), primaryAction: UIAction() { _ in
            demoVC.dismiss(animated: true)
        })
        dismiss.setTitle("Dismiss", for: .normal)
        demoView.addSubview(dismiss)
        dismiss.frame.size = CGSize(width: 100, height: 54)
        dismiss.frame.origin = CGPoint(x: demoView.bounds.size.width/2 - 50,
                                       y: demoView.bounds.size.height/2 - 27)
        
        
        return demoVC
    }
    
    func setupViews() {
        tv.frame = view.bounds
        tv.delegate = self
        view.addSubview(tv)
        tv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tv.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")

        let allItems = PresentationScenario.all
        
        var snapshot = datasource.snapshot()
        snapshot.appendSections(allItems.map{ return allItems.firstIndex(of: $0)! })
        for (idx, val) in allItems.enumerated() {
            snapshot.appendItems([val], toSection: idx)
        }
        
        datasource.apply(snapshot)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.hookIntoExistingCoordinator()
        case 1:
            self.onlyUseCustomAnimator()
        case 2:
            self.onlyPresentationController()
        case 3:
            self.animatorAndPresentationController()
        case 4:
            self.interactiveAnimatorAndPresentationController()
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

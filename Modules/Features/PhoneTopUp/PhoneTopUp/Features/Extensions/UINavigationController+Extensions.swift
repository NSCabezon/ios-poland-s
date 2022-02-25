//
//  UINavigationController+Extensions.swift
//  PhoneTopUp
//
//  Created by 188216 on 01/02/2022.
//

import Foundation

extension UINavigationController {
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        var vcs = viewControllers
        guard !vcs.isEmpty else {
            return
        }
        vcs[vcs.count - 1] = viewController
        setViewControllers(vcs, animated: animated)
      }
}

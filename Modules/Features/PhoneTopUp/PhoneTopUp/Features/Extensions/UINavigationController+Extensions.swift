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
    
    
    /// Pops to the first viewController with the specified type and then replaces it with the specified controller
    func popToViewControllerOfType<T: UIViewController>(_ type: T.Type, replaceWith controller: UIViewController, animated: Bool) {
        var vcs = viewControllers
        guard let indexOfControllerToReplace = vcs.firstIndex(where: { $0 is T }) else {
            return
        }
        
        vcs[indexOfControllerToReplace] = controller
        vcs = Array(vcs[0...indexOfControllerToReplace])
        setViewControllers(vcs, animated: animated)
    }
}

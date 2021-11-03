//
//  BackToLoginPageRouteHandler.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 18/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class BackToLoginPageRouteHandler {}

extension BackToLoginPageRouteHandler: RouteHandler {
    func handle(route: Route, on parent: UIViewController) -> Bool {
        guard route is BackToLoginPageRoute else {
            return false
        }

        popToLoginViewController(viewController: parent)

        return true
    }

    private func popToLoginViewController(viewController: UIViewController) {
        if let navigationController = viewController.navigationController {
            let foundLoginViewController = popNavigationController(navigationController: navigationController)
            if foundLoginViewController {
                return
            }
        }
        if let parent = viewController.parent {
            viewController.dismiss(animated: true)
            popToLoginViewController(viewController: parent)
        }
    }

    private func popNavigationController(navigationController: UINavigationController) -> Bool {
        let loginViewController = navigationController.viewControllers.reversed().first { $0 is LoginViewController }
        if let loginViewController = loginViewController {
            navigationController.popToViewController(loginViewController, animated: true)
            return true
        }
        return false
    }
}

//
//  SuccessfulLoginRouteHandler.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class SuccessfulLoginRouteHandler {
    private let successViewControllerFactory: AuthSuccessViewControllerProducing

    init(successViewControllerFactory: AuthSuccessViewControllerProducing) {
        self.successViewControllerFactory = successViewControllerFactory
    }
}

extension SuccessfulLoginRouteHandler: RouteHandler {
    func handle(route: Route, on parent: UIViewController) -> Bool {
        guard let route = route as? SuccessfulLoginRoute else {
            return false
        }
        let viewController = LoginSummaryViewControllerFactory().create(
            authToken: route.authToken,
            successViewControllerFactory: successViewControllerFactory
        )

        if let navigationController = parent.navigationController {
            navigationController.pushViewController(viewController, animated: true)
            return true
        }

        parent.present(viewController, animated: true)
        return true
    }
}

//
//  OpenSuccessViewRouteHandler.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class OpenSuccessViewRouteHandler {
    private let successViewControllerFactory: AuthSuccessViewControllerProducing

    init(successViewControllerFactory: AuthSuccessViewControllerProducing) {
        self.successViewControllerFactory = successViewControllerFactory
    }
}

extension OpenSuccessViewRouteHandler: RouteHandler {
    func handle(route: Route, on parent: UIViewController) -> Bool {
        guard let route = route as? OpenSuccessViewRoute else {
            return false
        }
        let viewController = successViewControllerFactory.create(
            authToken: route.authToken
        )

        if let navigationController = parent.navigationController {
            navigationController.pushViewController(viewController, animated: true)
            return true
        }

        parent.present(viewController, animated: true)
        return true
    }
}

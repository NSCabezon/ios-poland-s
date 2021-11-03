//
//  SmsRouteHandler.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class SmsRouteHandler {
    private let successViewControllerFactory: AuthSuccessViewControllerProducing

    init(successViewControllerFactory: AuthSuccessViewControllerProducing) {
        self.successViewControllerFactory = successViewControllerFactory
    }
}

extension SmsRouteHandler: RouteHandler {
    func handle(route: Route, on parent: UIViewController) -> Bool {
        guard let route = route as? SmsRoute else {
            return false
        }
        let viewController = SmsViewControllerFactory().create(
            authHost: route.authHost,
            loginInfo: route.loginInfo,
            encryptedPassword: route.encryptedPassword,
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

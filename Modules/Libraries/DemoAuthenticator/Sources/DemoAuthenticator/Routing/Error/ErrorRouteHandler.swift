//
//  ErrorRouteHandler.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 18/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class ErrorRouteHandler {}

extension ErrorRouteHandler: RouteHandler {
    func handle(route: Route, on parent: UIViewController) -> Bool {
        guard let route = route as? ErrorRoute else {
            return false
        }

        let message = route.error.localizedDescription

        let alert = UIAlertController(
            title: "Błąd",
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )

        alert.addAction(action)

        parent.present(alert, animated: true)

        return true
    }
}

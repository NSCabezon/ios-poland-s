//
//  Router.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class Router {
    private let handlers: [RouteHandler]
    weak var parent: UIViewController?

    init(handlers: [RouteHandler]) {
        self.handlers = handlers
    }

    func route(to route: Route) {
        guard let parent = parent else {
            return
        }
        _ = handlers.first { handler in
            handler.handle(route: route, on: parent)
        }
    }
}

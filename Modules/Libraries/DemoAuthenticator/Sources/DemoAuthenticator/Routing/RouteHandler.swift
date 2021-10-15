//
//  RouteHandler.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

protocol RouteHandler {
    func handle(route: Route, on parent: UIViewController) -> Bool
}

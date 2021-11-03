//
//  AuthSuccessViewControllerProducing.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

public protocol AuthSuccessViewControllerProducing {
    func create(authToken: AuthToken) -> UIViewController
}

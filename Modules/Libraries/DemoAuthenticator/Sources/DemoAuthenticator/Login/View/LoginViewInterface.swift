//
//  LoginViewInterface.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

protocol LoginViewInterface: UIView {
    var authHostLabel: UILabel { get }
    var authHost: UITextField { get }
    var nikLabel: UILabel { get }
    var nik: UITextField { get }
    var passwordLabel: UILabel { get }
    var password: UITextField { get }
    var submit: UIButton { get }
}

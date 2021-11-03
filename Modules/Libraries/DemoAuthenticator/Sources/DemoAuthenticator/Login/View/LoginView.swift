//
//  LoginView.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class LoginView: UIView {
    let authHostLabel = UILabel()
    let authHost = UITextField()
    let nikLabel = UILabel()
    let nik = UITextField()
    let passwordLabel = UILabel()
    let password = UITextField()
    let submit = UIButton()
}

extension LoginView: LoginViewInterface {}

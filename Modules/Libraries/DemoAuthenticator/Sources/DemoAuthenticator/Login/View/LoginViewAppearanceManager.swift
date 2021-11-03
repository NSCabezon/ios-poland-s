//
//  LoginViewAppearanceManager.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class LoginViewAppearanceManager {
    private let viewDecorator: ViewDecorating

    init(
        viewDecorator: ViewDecorating
    ) {
        self.viewDecorator = viewDecorator
    }
}

extension LoginViewAppearanceManager: LoginViewAppearanceManaging {
    func decorate(view: LoginViewInterface) {
        view.backgroundColor = .white

        viewDecorator.decorate(view: view.authHost)
        view.authHost.textContentType = .URL

        viewDecorator.decorate(view: view.nik)
        if #available(iOS 11.0, *) {
            view.nik.textContentType = .username
        }

        viewDecorator.decorate(view: view.password)
        view.password.isSecureTextEntry = true
        if #available(iOS 11.0, *) {
            view.password.textContentType = .password
        }

        viewDecorator.decorate(view: view.submit)
    }
}

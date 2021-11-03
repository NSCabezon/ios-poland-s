//
//  LoginViewFactory.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

final class LoginViewFactory {
    private let layoutManager: LoginViewLayoutManaging
    private let appearanceManager: LoginViewAppearanceManaging

    init(
        layoutManager: LoginViewLayoutManaging,
        appearanceManager: LoginViewAppearanceManaging
    ) {
        self.layoutManager = layoutManager
        self.appearanceManager = appearanceManager
    }
}

extension LoginViewFactory: LoginViewProducing {
    func create() -> LoginViewInterface {
        let view = LoginView()
        layoutManager.layout(view: view)
        appearanceManager.decorate(view: view)
        return view
    }
}

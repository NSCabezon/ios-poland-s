//
//  LoginViewControllerFactory.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

public final class LoginViewControllerFactory {
    public init() {}

    public func create(successViewControllerFactory: AuthSuccessViewControllerProducing) -> UIViewController {
        let layoutManager = LoginViewLayoutManager()
        let viewDecorator = MultiViewDecorator(
            decorators: [
                TextFieldDecorator(),
                ButtonDecorator(),
            ]
        )
        let appearanceManager = LoginViewAppearanceManager(
            viewDecorator: viewDecorator
        )
        let viewFactory = LoginViewFactory(
            layoutManager: layoutManager,
            appearanceManager: appearanceManager
        )

        var logger: Logger?
        #if DEBUG
        logger = ConsoleLogger(level: .info)
        #endif
        let dataTaskRunner = DataTaskRunner(logger: logger)
        let jsonDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        let errorResponseDecoder = ErrorResponseJSONDecoder(jsonDecoder: jsonDecoder)

        let loginInitEndpoint = LoginInitEndpoint(
            dataTaskRunner: dataTaskRunner,
            errorResponseDecoder: errorResponseDecoder
        )
        let pubKeyEndpoint = PubKeyEndpoint(dataTaskRunner: dataTaskRunner)
        let authenticateInitEndpoint = AuthenticateInitEndpoint(
            dataTaskRunner: dataTaskRunner,
            errorResponseDecoder: errorResponseDecoder
        )
        let passwordUseCase = PasswordUseCase()
        let encryptTextUseCase = EncryptTextUseCase()
        let loginUseCase = LoginUseCase(
            loginInitEndpoint: loginInitEndpoint,
            pubKeyEndpoint: pubKeyEndpoint,
            authenticateInitEndpoint: authenticateInitEndpoint,
            passwordUseCase: passwordUseCase,
            encryptTextUseCase: encryptTextUseCase
        )

        let userDefaults = UserDefaults.standard
        let preferencesUseCase = PreferencesUseCase(
            userDefaults: userDefaults
        )
        
        let viewModel = LoginViewModel(
            loginUseCase: loginUseCase,
            preferencesUseCase: preferencesUseCase
        )

        let router = Router(handlers: [
            SmsRouteHandler(successViewControllerFactory: successViewControllerFactory),
            ErrorRouteHandler(),
        ])

        let viewController = LoginViewController(
            viewFactory: viewFactory,
            viewModel: viewModel,
            router: router
        )

        router.parent = viewController
        
        return viewController
    }
}

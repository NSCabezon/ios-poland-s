//
//  SmsViewControllerFactory.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class SmsViewControllerFactory {
    func create(
        authHost: URL,
        loginInfo: LoginInfoResponse,
        encryptedPassword: String,
        successViewControllerFactory: AuthSuccessViewControllerProducing
    ) -> UIViewController {
        let viewDecorator = MultiViewDecorator(
            decorators: [
                TextFieldDecorator(),
                ButtonDecorator(),
            ]
        )
        let viewFactory = SmsViewFactory(
            viewDecorator: viewDecorator
        )

        var logger: Logger?
        #if DEBUG
        logger = ConsoleLogger(level: .info)
        #endif
        let dataTaskRunner = DataTaskRunner(logger: logger)
        let smsAuthenticationEndpoint = SmsAuthenticationEndpoint(dataTaskRunner: dataTaskRunner)
        let smsAuthenticateUseCase = SmsAuthenticateUseCase(
            smsAuthenticationEndpoint: smsAuthenticationEndpoint,
            authHost: authHost,
            loginInfo: loginInfo,
            encryptedPassword: encryptedPassword
        )
        let viewModel = SmsViewModel(
            smsAuthenticateUseCase: smsAuthenticateUseCase
        )

        let router = Router(handlers: [
            SuccessfulLoginRouteHandler(successViewControllerFactory: successViewControllerFactory),
            ErrorRouteHandler(),
        ])
        let viewController = SmsViewController(
            viewFactory: viewFactory,
            viewModel: viewModel,
            router: router
        )

        router.parent = viewController

        return viewController
    }
}

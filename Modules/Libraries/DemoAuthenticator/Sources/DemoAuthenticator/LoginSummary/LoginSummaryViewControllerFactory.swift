//
//  LoginSummaryViewControllerFactory.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class LoginSummaryViewControllerFactory {
    func create(
        authToken: AuthToken,
        successViewControllerFactory: AuthSuccessViewControllerProducing
    ) -> UIViewController {
        let viewDecorator = MultiViewDecorator(
            decorators: [
                ButtonDecorator(),
            ]
        )
        let viewFactory = LoginSummaryViewFactory(viewDecorator: viewDecorator)

        let logoutUseCase = LogoutUseCase()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let viewModel = LoginSummaryViewModel(
            authToken: authToken,
            logoutUseCase: logoutUseCase,
            dateFormatter: dateFormatter
        )

        let router = Router(handlers: [
            OpenSuccessViewRouteHandler(successViewControllerFactory: successViewControllerFactory),
            BackToLoginPageRouteHandler(),
            ErrorRouteHandler(),
        ])

        let viewController = LoginSummaryViewController(
            viewFactory: viewFactory,
            viewModel: viewModel,
            router: router
        )
        router.parent = viewController

        return viewController
    }
}

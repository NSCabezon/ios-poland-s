//
//  LoginSummaryViewFactory.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class LoginSummaryViewFactory {
    private let viewDecorator: ViewDecorating

    init(
        viewDecorator: ViewDecorating
    ) {
        self.viewDecorator = viewDecorator
    }

    func create() -> LoginSummaryView {
        let view = LoginSummaryView()
        layout(view: view)
        decorate(view: view)
        return view
    }

    func layout(view: LoginSummaryView) {
        view.tokenExpirationDate.translatesAutoresizingMaskIntoConstraints = false
        view.tokenValue.translatesAutoresizingMaskIntoConstraints = false
        view.logout.translatesAutoresizingMaskIntoConstraints = false
        view.openSuccessView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(view.tokenExpirationDate)
        view.addSubview(view.tokenValue)
        view.addSubview(view.logout)
        view.addSubview(view.openSuccessView)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                view.tokenExpirationDate.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.tokenExpirationDate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
                view.tokenExpirationDate.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

                view.tokenValue.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.tokenValue.topAnchor.constraint(equalTo: view.tokenExpirationDate.safeAreaLayoutGuide.bottomAnchor, constant: 16),
                view.tokenValue.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

                view.logout.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                view.logout.topAnchor.constraint(equalTo: view.tokenValue.safeAreaLayoutGuide.bottomAnchor, constant: 24),

                view.openSuccessView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                view.openSuccessView.topAnchor.constraint(equalTo: view.logout.safeAreaLayoutGuide.bottomAnchor, constant: 36),

            ])
        } else {
            NSLayoutConstraint.activate([
                view.tokenExpirationDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.tokenExpirationDate.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
                view.tokenExpirationDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

                view.tokenValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.tokenValue.topAnchor.constraint(equalTo: view.tokenExpirationDate.bottomAnchor, constant: 16),
                view.tokenValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

                view.logout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                view.logout.topAnchor.constraint(equalTo: view.tokenValue.bottomAnchor, constant: 24),

                view.openSuccessView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                view.openSuccessView.topAnchor.constraint(equalTo: view.logout.bottomAnchor, constant: 36),

            ])
        }
    }

    func decorate(view: LoginSummaryView) {
        view.backgroundColor = .white

        view.tokenValue.numberOfLines = 0
        view.tokenValue.lineBreakMode = .byCharWrapping

        viewDecorator.decorate(view: view.logout)
        viewDecorator.decorate(view: view.openSuccessView)
    }
}

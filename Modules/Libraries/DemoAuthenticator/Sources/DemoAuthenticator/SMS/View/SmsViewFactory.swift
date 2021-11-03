//
//  SmsViewFactory.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class SmsViewFactory {
    private let viewDecorator: ViewDecorating

    init(
        viewDecorator: ViewDecorating
    ) {
        self.viewDecorator = viewDecorator
    }

    func create() -> SmsView {
        let view = SmsView()
        layout(view: view)
        decorate(view: view)
        return view
    }

    func layout(view: SmsView) {
        view.smsCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.smsCode.translatesAutoresizingMaskIntoConstraints = false
        view.submit.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(view.smsCodeLabel)
        view.addSubview(view.smsCode)
        view.addSubview(view.submit)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                view.smsCodeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.smsCodeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
                view.smsCodeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

                view.smsCode.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.smsCode.topAnchor.constraint(equalTo: view.smsCodeLabel.safeAreaLayoutGuide.bottomAnchor, constant: 4),
                view.smsCode.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                view.smsCode.heightAnchor.constraint(equalToConstant: 32),

                view.submit.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.submit.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                view.submit.topAnchor.constraint(equalTo: view.smsCode.bottomAnchor, constant: 32),

            ])
        } else {
            NSLayoutConstraint.activate([
                view.smsCodeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.smsCodeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
                view.smsCodeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

                view.smsCode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.smsCode.topAnchor.constraint(equalTo: view.smsCodeLabel.bottomAnchor, constant: 4),
                view.smsCode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                view.smsCode.heightAnchor.constraint(equalToConstant: 32),

                view.submit.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.submit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                view.submit.topAnchor.constraint(equalTo: view.smsCode.bottomAnchor, constant: 32),

            ])
        }
    }

    func decorate(view: SmsView) {
        view.backgroundColor = .white

        viewDecorator.decorate(view: view.smsCode)
        view.smsCode.isSecureTextEntry = true
        if #available(iOS 11.0, *) {
            view.smsCode.textContentType = .password
        }

        viewDecorator.decorate(view: view.submit)
    }
}

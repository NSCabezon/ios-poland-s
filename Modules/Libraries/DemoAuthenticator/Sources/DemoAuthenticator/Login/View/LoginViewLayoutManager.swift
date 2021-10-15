//
//  LoginViewLayoutManager.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class LoginViewLayoutManager {}

extension LoginViewLayoutManager: LoginViewLayoutManaging {
    func layout(view: LoginViewInterface) {
        view.authHostLabel.translatesAutoresizingMaskIntoConstraints = false
        view.authHost.translatesAutoresizingMaskIntoConstraints = false
        view.nikLabel.translatesAutoresizingMaskIntoConstraints = false
        view.nik.translatesAutoresizingMaskIntoConstraints = false
        view.passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        view.password.translatesAutoresizingMaskIntoConstraints = false
        view.submit.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(view.authHostLabel)
        view.addSubview(view.authHost)
        view.addSubview(view.nikLabel)
        view.addSubview(view.nik)
        view.addSubview(view.passwordLabel)
        view.addSubview(view.password)
        view.addSubview(view.submit)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                view.authHostLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.authHostLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
                view.authHostLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

                view.authHost.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.authHost.topAnchor.constraint(equalTo: view.authHostLabel.safeAreaLayoutGuide.bottomAnchor, constant: 4),
                view.authHost.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                view.authHost.heightAnchor.constraint(equalToConstant: 32),

                view.nikLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.nikLabel.topAnchor.constraint(equalTo: view.authHost.bottomAnchor, constant: 24),
                view.nikLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

                view.nik.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.nik.topAnchor.constraint(equalTo: view.nikLabel.bottomAnchor, constant: 4),
                view.nik.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                view.nik.heightAnchor.constraint(equalToConstant: 32),

                view.passwordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.passwordLabel.topAnchor.constraint(equalTo: view.nik.bottomAnchor, constant: 24),
                view.passwordLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

                view.password.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                view.password.topAnchor.constraint(equalTo: view.passwordLabel.bottomAnchor, constant: 4),
                view.password.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                view.password.heightAnchor.constraint(equalToConstant: 32),

                view.submit.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                view.submit.topAnchor.constraint(equalTo: view.password.bottomAnchor, constant: 32),
            ])
        } else {
            NSLayoutConstraint.activate([
                view.authHostLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.authHostLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
                view.authHostLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

                view.authHost.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.authHost.topAnchor.constraint(equalTo: view.authHostLabel.bottomAnchor, constant: 4),
                view.authHost.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                view.authHost.heightAnchor.constraint(equalToConstant: 32),

                view.nikLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.nikLabel.topAnchor.constraint(equalTo: view.authHost.bottomAnchor, constant: 24),
                view.nikLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

                view.nik.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.nik.topAnchor.constraint(equalTo: view.nikLabel.bottomAnchor, constant: 4),
                view.nik.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                view.nik.heightAnchor.constraint(equalToConstant: 32),

                view.passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.passwordLabel.topAnchor.constraint(equalTo: view.nik.bottomAnchor, constant: 24),
                view.passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

                view.password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                view.password.topAnchor.constraint(equalTo: view.passwordLabel.bottomAnchor, constant: 4),
                view.password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                view.password.heightAnchor.constraint(equalToConstant: 32),

                view.submit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                view.submit.topAnchor.constraint(equalTo: view.password.bottomAnchor, constant: 32),
            ])
        }
        
    }
}

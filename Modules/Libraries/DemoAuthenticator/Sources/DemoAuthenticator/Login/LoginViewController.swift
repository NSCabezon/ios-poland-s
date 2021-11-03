//
//  LoginViewController.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    private let viewFactory: LoginViewFactory
    private let viewModel: LoginViewModel
    private let router: Router

    private lazy var loginView = viewFactory.create()

    init(
        viewFactory: LoginViewFactory,
        viewModel: LoginViewModel,
        router: Router
    ) {
        self.viewFactory = viewFactory
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        setupLabels()
        setupInputs()
        setupTargets()
    }

    private func setupLabels() {
        loginView.authHostLabel.text = "Adres serwera autoryzacji"
        loginView.authHost.text = "https://pluton2.centrum24.pl/centrum24-rest/"
        loginView.nikLabel.text = "NIK"
        loginView.passwordLabel.text = "Hasło"
        loginView.submit.setTitle("Wyślij SMS", for: .normal)
    }

    private func setupInputs() {
        guard let loginModel = viewModel.loadLoginModel() else {
            return
        }

        loginView.authHost.text = loginModel.authHost.absoluteString
        loginView.nik.text = String(loginModel.nik)
        loginView.password.text = loginModel.password
    }

    private func setupTargets() {
        loginView.submit.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
    }

    @objc private func onSubmit() {
        guard
            let nikString = loginView.nik.text,
            let nik = Int(nikString),
            let password = loginView.password.text,
            let authHostString = loginView.authHost.text,
            let authHost = URL(string: authHostString)
        else {
            return
        }

        let loginModel = LoginModel(
            authHost: authHost,
            nik: nik,
            password: password
        )

        viewModel.save(loginModel: loginModel)

        let router = self.router

        view.isUserInteractionEnabled = false
        viewModel.login(loginModel: loginModel) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.view?.isUserInteractionEnabled = true
                switch result {
                case let .success(route):
                    router.route(to: route)
                case let .failure(error):
                    router.route(to: ErrorRoute(error: error))
                }
            }
        }
    }
}

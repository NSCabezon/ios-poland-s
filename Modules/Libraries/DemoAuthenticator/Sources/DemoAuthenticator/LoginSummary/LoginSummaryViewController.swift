//
//  LoginSummaryViewController.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class LoginSummaryViewController: UIViewController {
    private let viewFactory: LoginSummaryViewFactory
    private let viewModel: LoginSummaryViewModel
    private let router: Router

    private lazy var loginSummaryView = viewFactory.create()

    init(
        viewFactory: LoginSummaryViewFactory,
        viewModel: LoginSummaryViewModel,
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
        view = loginSummaryView
    }

    override func viewDidLoad() {
        navigationItem.setHidesBackButton(true, animated: true)
        setupLabels()
        setupTargets()
    }

    func setupLabels() {
        loginSummaryView.tokenExpirationDate.text = "Ważność: \(viewModel.tokenExpirationDate)"
        loginSummaryView.tokenValue.text = "Token: \(viewModel.accessToken)"
        loginSummaryView.logout.setTitle("Wyloguj", for: .normal)
        loginSummaryView.openSuccessView.setTitle("Otwórz moduł", for: .normal)
    }

    func setupTargets() {
        loginSummaryView.logout.addTarget(self, action: #selector(onLogout), for: .touchUpInside)
        loginSummaryView.openSuccessView.addTarget(self, action: #selector(onOpenSuccessView), for: .touchUpInside)
    }

    @objc private func onLogout() {
        viewModel.logout { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .failure(error):
                strongSelf.router.route(to: ErrorRoute(error: error))
            case let .success(route):
                strongSelf.router.route(to: route)
            }
        }
    }

    @objc private func onOpenSuccessView() {
        let route = OpenSuccessViewRoute(authToken: viewModel.authToken)
        router.route(to: route)
    }
}

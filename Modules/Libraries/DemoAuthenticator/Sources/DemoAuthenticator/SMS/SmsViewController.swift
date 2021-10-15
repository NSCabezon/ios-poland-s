//
//  SmsViewController.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class SmsViewController: UIViewController {
    private let viewFactory: SmsViewFactory
    private let viewModel: SmsViewModel
    private let router: Router

    private lazy var smsView = viewFactory.create()

    init(
        viewFactory: SmsViewFactory,
        viewModel: SmsViewModel,
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
        view = smsView
    }

    override func viewDidLoad() {
        setupLabels()
        setupTargets()
    }

    private func setupLabels() {
        smsView.smsCodeLabel.text = "Kod SMS"
        smsView.submit.setTitle("Zaloguj", for: .normal)
    }

    private func setupTargets() {
        smsView.submit.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
    }

    @objc private func onSubmit() {
        guard
            let smsCode = smsView.smsCode.text
        else {
            return
        }

        let router = self.router

        view.isUserInteractionEnabled = false
        viewModel.authenticate(smsCode: smsCode) { [weak self] result in
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

    @objc private func onCancel() {
        navigationController?.popViewController(animated: true)
    }
}

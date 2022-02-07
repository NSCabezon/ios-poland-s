//
//  OneAppInitViewController.swift
//  Santander
//
//  Created by 186489 on 07/06/2021.
//

import Foundation
import UIKit
import UI
import PLUI
import Commons
import PLCommons
import PLCommonOperatives
import CoreFoundationLib
import PhoneTopUp

final class OneAppInitViewController: UIViewController, ErrorPresentable, LoaderPresentable {
    
    private weak var delegate: OneAppInitCoordinatorDelegate?
    private let modules: [OneAppInitModule]
    private let dependencyResolver: DependenciesResolver
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var useCaseHandler: UseCaseHandler {
        dependencyResolver.resolve(for: UseCaseHandler.self)
    }
    
    init(dependencyResolver: DependenciesResolver, modules: [OneAppInitModule], delegate: OneAppInitCoordinatorDelegate?) {
        self.modules = modules
        self.delegate = delegate
        self.dependencyResolver = dependencyResolver
        super.init(nibName: nil, bundle: nil)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setUpView()
        setUpSubviews()
        setUpLayouts()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func setUpSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        modules.forEach { module in
            let button = RedLisboaButton()
            button.labelButtonLines(numberOfLines: 2)
            button.setTextAligment(.center, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            
            button.addAction { [weak self] in
                guard let self = self else { return }
                
                switch module {
                case .charityTransfer:
                    Scenario(useCase: GetAccountsForDebitUseCase(transactionType: .charityTransfer, dependenciesResolver: self.dependencyResolver))
                        .execute(on: self.useCaseHandler)
                        .onSuccess { accounts in
                            if accounts.isEmpty {
                                self.showServiceInaccessibleMessage(onConfirm: nil)
                                return
                            }
                            self.delegate?.selectCharityTransfer(accounts: accounts)
                        }
                        .onError { _ in
                            self.showServiceInaccessibleMessage(onConfirm: nil)
                        }
                case .zusTransfer:
                    Scenario(
                        useCase: GetAccountsForDebitUseCase(
                            transactionType: .zusTransfer,
                            dependenciesResolver: self.dependencyResolver
                        )
                    )
                    .execute(on: self.useCaseHandler)
                    .onSuccess { accounts in
                        if accounts.isEmpty {
                            self.showServiceInaccessibleMessage(onConfirm: nil)
                            return
                        }
                        self.delegate?.selectZusTransfer(accounts: accounts)
                    }
                    .onError { _ in
                        self.showServiceInaccessibleMessage(onConfirm: nil)
                    }
                default:
                    self.delegate?.selectModule(module)
                }
            }
            button.setTitle(module.rawValue, for: .normal)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setUpLayouts() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func showError() {
        showServiceInaccessibleMessage(onConfirm: nil)
    }
    
    private func setupNavigationBar() {
        NavigationBarBuilder(style: .sky,
                             title: .title(key: "Module list"))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }
    
    @objc private func didSelectBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

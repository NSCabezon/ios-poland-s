//
//  ViewController.swift
//  CharityTransfer
//
//  Created by mateniec on 09/21/2021.
//  Copyright (c) 2021 mateniec. All rights reserved.
//

import UIKit
import Commons
import CharityTransfer
import SANPLLibrary
import CoreFoundationLib
import PLCommonOperatives
import PLCommons

class ViewController: UIViewController {

    private lazy var dependenciesResolver: DependenciesResolver = {
        let defaultResolver = DependenciesDefault()
        
        defaultResolver.register(for: PLManagersProviderProtocol.self) { resolver in
            return MockManager(resolver: resolver)
        }
        
        defaultResolver.register(for: PLHostProviderProtocol.self) { resolver in
            return MockHostProvider()
        }
        
        defaultResolver.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8)
        }
        
        defaultResolver.register(for: StringLoader.self) { _ in
            return MockStringLoader()
        }
        
        return defaultResolver
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentModule()
    }
    
    private func presentModule() {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        
        Scenario(useCase: GetAccountsForDebitUseCase(transactionType: .charityTransfer, dependenciesResolver: self.dependenciesResolver))
            .execute(on: self.dependenciesResolver.resolve(for: UseCaseHandler.self))
            .onSuccess { [weak self] accounts in
                guard let self = self else { return }
                let coordinator = CharityTransferAccountSelectorCoordinator(
                    dependenciesResolver: self.dependenciesResolver,
                    navigationController: navigationController,
                    accounts: accounts,
                    selectedAccountNumber: "",
                    sourceView: .sendMoney,
                    charityTransferSettings: CharityTransferSettings(
                        transferRecipientName: "Fundacja Santander",
                        transferAccountNumber: "26 1090 0088 0000 0001 4223 0553",
                        transferTitle: "Darowizna dla Fundacji Santander"
                    )
                )
                coordinator.start()
            }
        
        self.present(navigationController, animated: true, completion: nil)
    }
}


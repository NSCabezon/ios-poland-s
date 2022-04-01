//
//  ViewController.swift
//  SplitPayment
//
//  Created by 187830 on 03/15/2022.
//

import UIKit
import CoreFoundationLib
import SplitPayment
import SANPLLibrary
import PLCommonOperatives

class ViewController: UIViewController {

    private lazy var dependenciesResolver: DependenciesResolver = {
        let defaultResolver = DependenciesDefault()
        
        defaultResolver.register(for: UseCaseScheduler.self) { resolver in
            return resolver.resolve(for: UseCaseHandler.self)
        }
        
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
        
        defaultResolver.register(for: BankingUtilsProtocol.self) { resolver in
            BankingUtils(dependencies: resolver)
        }
        
        defaultResolver.register(for: PLTransfersRepository.self) { _ in
            PLTransfersRepositoryMock()
        }
        
        defaultResolver.register(for: ChallengesHandlerDelegate.self) { _ in
            PLAuthorizationCoordinatorMock()
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
        
        Scenario(useCase: GetAccountsForDebitUseCase(transactionType: .splitPayment, dependenciesResolver: self.dependenciesResolver))
            .execute(on: self.dependenciesResolver.resolve(for: UseCaseHandler.self))
            .onSuccess { [weak self] accounts in
                guard let self = self else { return }
                
                let coordinator = SplitPaymentModuleCoordinator(dependenciesResolver: self.dependenciesResolver,
                                                                navigationController: navigationController)
                coordinator.start()
            }
        
        self.present(navigationController, animated: true, completion: nil)
    }

}


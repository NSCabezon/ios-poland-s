//
//  ViewController.swift
//  BLIK
//
//  Created by agnieszka.szczurek on 05/24/2021.
//  Copyright (c) 2021 agnieszka.szczurek. All rights reserved.
//

import UIKit
import BLIK
import CoreFoundationLib
import SANPLLibrary
import PLHelpCenter
import Operative

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
        
        defaultResolver.register(for: PLOnlineAdvisorManagerProtocol.self) { resolver in
            return OnlineAdvisorManagerMock()
        }
        
        defaultResolver.register(for: PLTransfersRepository.self) { _ in
            PLTransfersRepositoryMock()
        }
        
        defaultResolver.register(for: BlikChallengesHandlerDelegate.self) { _ in
            PLAuthorizationCoordinatorMock(challengeVerification: ChallengeVerificationStub())
        }
        
        defaultResolver.register(for: CoreSessionManager.self) { _ in
            CoreSessionManagerMock()
        }
        
        defaultResolver.register(for: OperativeContainerCoordinatorDelegate.self) { _ in
            OperativeContainerCoordinatorDelegateMock()
        }
        
        return defaultResolver
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentModule()
    }

    private func presentModule() {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen

        let coordinator = BLIKHomeCoordinator(dependenciesResolver: dependenciesResolver, navigationController: navigationController)
        coordinator.start()
        
        self.present(navigationController, animated: true, completion: nil)
    }
}

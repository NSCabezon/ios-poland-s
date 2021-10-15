//
//  ViewController.swift
//  BLIK
//
//  Created by agnieszka.szczurek on 05/24/2021.
//  Copyright (c) 2021 agnieszka.szczurek. All rights reserved.
//

import UIKit
import BLIK
import Commons
import SANPLLibrary

class ViewController: UIViewController {

    private lazy var dependenciesResolver: DependenciesResolver = {
        let defaultResolver = DependenciesDefault()
        
        defaultResolver.register(for: PLManagersProviderProtocol.self) { resolver in
            return MockManager(resolver: resolver)
        }
        
        defaultResolver.register(for: PLHostProviderProtocol.self) { resolver in
            return MockHostProvider()
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

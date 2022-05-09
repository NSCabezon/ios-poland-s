//
//  TopUpConfirmationCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 13/01/2022.
//

import CoreFoundationLib
import Foundation
import UI
import PLCommons

protocol TopUpConfirmationCoordinatorProtocol: AnyObject, ModuleCoordinator {
    func back()
    func close()
    func showSummary(with model: TopUpModel)
}

final class TopUpConfirmationCoordinator: TopUpConfirmationCoordinatorProtocol {
    // MARK: Properties
    
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let summary: TopUpModel
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         summary: TopUpModel) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.summary = summary
        self.setupDependencies(with: summary)
    }
    
    // MARK: SetUp
    
    private func setupDependencies(with summary: TopUpModel) {
        dependenciesEngine.register(for: PLDomesticTransactionParametersGenerable.self) { _ in
            return PLDomesticTransactionParametersProvider()
        }
        dependenciesEngine.register(for: PLTransactionParametersProviderProtocol.self) { resolver in
            return PLTransactionParametersProvider(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PerformTopUpTransactionInputMapping.self) { resolver in
            return PerformTopUpTransactionInputMapper(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: TopUpSummaryMapping.self) { _ in
            return TopUpSummaryMapper()
        }
        
        self.dependenciesEngine.register(for: TopUpConfirmationCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: TopUpConfirmationPresenterProtocol.self) { resolver in
            return TopUpConfirmationPresenter(dependenciesResolver: resolver, summary: summary)
        }

        self.dependenciesEngine.register(for: TopUpConfirmationViewController.self) { resolver in
            let presenter = resolver.resolve(for: TopUpConfirmationPresenterProtocol.self)
            let viewController = TopUpConfirmationViewController(
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    // MARK: Methods
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: TopUpConfirmationViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.closeTopUpProces()
    }
    
    func showSummary(with model: TopUpModel) {
        let coordinator = TopUpSummaryCoordinator(dependenciesResolver: dependenciesEngine,
                                                  navigationController: navigationController,
                                                  summary: summary)
        coordinator.start()
    }
}

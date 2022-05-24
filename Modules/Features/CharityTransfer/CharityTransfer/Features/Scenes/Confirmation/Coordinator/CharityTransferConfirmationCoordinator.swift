//
//  CharityTransferConfirmationCoordinator.swift
//  CharityTransfer
//
//  Created by 187830 on 08/11/2021.
//

import UI
import PLUI
import CoreFoundationLib
import PLCommons
import SANPLLibrary
import PLCryptography

protocol CharityTransferConfirmationCoordinatorProtocol {
    func pop()
    func backToTransfer()
    func showSummary(with model: CharityTransferSummary)
    func closeAuthorization()
}

final class CharityTransferConfirmationCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let model: CharityTransferModel

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         model: CharityTransferModel) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.model = model
        setupDependencies()
    }
    
    func start() {
        let controller =  dependenciesEngine.resolve(for: CharityTransferConfirmationViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

private extension CharityTransferConfirmationCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: CharityTransferConfirmationCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: CharityTransferConfirmationPresenterProtocol.self) { [weak self] resolver in
            CharityTransferConfirmationPresenter(dependenciesResolver: resolver, model: self?.model)
        }
        dependenciesEngine.register(for: CharityTransferConfirmationViewController.self) { resolver in
            var presenter = resolver.resolve(for: CharityTransferConfirmationPresenterProtocol.self)
            let viewController =  CharityTransferConfirmationViewController(
                presenter: presenter
            )
            presenter.view = viewController
            return viewController
        }
        dependenciesEngine.register(for: AcceptCharityTransactionProtocol.self) { resolver in
            AcceptCharityTransactionUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: PLTrustedHeadersGenerable.self) { resolver in
             PLTrustedHeadersProvider(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: PLDomesticTransactionParametersGenerable.self) { _ in
             PLDomesticTransactionParametersProvider()
        }
        dependenciesEngine.register(for: PLTransactionParametersProviderProtocol.self) { resolver in
             PLTransactionParametersProvider(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: CharityTransferSummaryMapping.self) { _ in
            CharityTransferSummaryMapper()
        }
        dependenciesEngine.register(for: CharityTransferSendMoneyInputMapping.self) { resolver in
            CharityTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
    }
}

extension CharityTransferConfirmationCoordinator: CharityTransferConfirmationCoordinatorProtocol {

    func pop() {
        navigationController?.popViewController(animated: true)
    }

    func backToTransfer() {
        let accountSelectorViewControllerIndex = navigationController?.viewControllers.firstIndex {
            $0 is AccountSelectorViewController
        }
        guard let accountSelectorViewControllerIndex = accountSelectorViewControllerIndex,
              let parentController = navigationController?.viewControllers[safe: accountSelectorViewControllerIndex - 1] else {
            let charityTransferFormViewControllerIndex = navigationController?.viewControllers.firstIndex {
                $0 is CharityTransferFormViewController
            }
            if let charityTransferFormViewControllerIndex = charityTransferFormViewControllerIndex,
               let parentController = navigationController?.viewControllers[safe: charityTransferFormViewControllerIndex - 1] {
                navigationController?.popToViewController(parentController, animated: true)
                return
            }
            navigationController?.popViewController(animated: true)
            return
            
        }
        navigationController?.popToViewController(parentController, animated: true)
    }
    
    func showSummary(with model: CharityTransferSummary) {
        let coordinator = CharityTransferSummaryCoordinator(dependenciesResolver: dependenciesEngine,
                                                           navigationController: navigationController,
                                                           summary: model)
        coordinator.start()
    }
    
    func closeAuthorization() {
        guard let confirmationVC = navigationController?.viewControllers.first(where: {
            $0 is CharityTransferConfirmationViewController
        }) else { return }
        navigationController?.popToViewController(confirmationVC, animated: false)
    }
}


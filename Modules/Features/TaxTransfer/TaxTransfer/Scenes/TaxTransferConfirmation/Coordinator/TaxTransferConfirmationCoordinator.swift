//
//  TaxTransferConfirmationCoordinator.swift
//  TaxTransfer
//
//  Created by 187831 on 24/03/2022.
//

import CoreFoundationLib
import Foundation
import UI
import PLUI
import PLCommons
import PLCommonOperatives

protocol TaxTransferConfirmationCoordinatorProtocol {
    func goToGlobalPosition()
    func backToForm()
    func closeAuthorizationFlow()
    func showSummary(
        with summaryModel: TaxTransferSummary,
        transferModel: TaxTransferModel
    )
}

final class TaxTransferConfirmationCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let model: TaxTransferModel
    
    init(dependenciesResolver: DependenciesResolver,
         model: TaxTransferModel,
         navigationController: UINavigationController?) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.model = model
        setUpDependencies()
    }
    
    func start() {
        let presenter = TaxTransferConfirmationPresenter(
            dependenciesResolver: dependenciesEngine,
            model: model
        )
        let controller = TaxTransferConfirmationViewController(
            confirmationDialogFactory: confirmationDialogFactory,
            model: model,
            presenter: presenter
        )
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TaxTransferConfirmationCoordinator: TaxTransferConfirmationCoordinatorProtocol {
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func backToForm() {
        guard let formViewController = navigationController?.viewControllers.first(
            where: { $0 is TaxTransferFormViewController }
        ) else { return }
        navigationController?.popToViewController(formViewController, animated: true)
    }
    
    func showSummary(with summaryModel: TaxTransferSummary, transferModel: TaxTransferModel) {
        let coordinator = TaxTransferSummaryCoordinator(
            dependenciesResolver: dependenciesEngine,
            summaryModel: summaryModel,
            transferModel: transferModel,
            navigationController: navigationController
        )
        coordinator.start()
    }
    
    func closeAuthorizationFlow() {
        guard let confirmationVC = navigationController?.viewControllers.first(where: {
            $0 is TaxTransferConfirmationViewController
        }) else {
            return
        }
        navigationController?.popToViewController(confirmationVC, animated: false)
    }
}

private extension TaxTransferConfirmationCoordinator {
    var confirmationDialogFactory: ConfirmationDialogProducing {
        return dependenciesEngine.resolve()
    }
    
    func setUpDependencies() {
        dependenciesEngine.register(for: TaxTransferConfirmationCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: TaxTransferSummaryMapping.self) { _ in
            return TaxTransferSummaryMapper()
        }
        
        dependenciesEngine.register(for: AcceptTaxTransactionProtocol.self) { resolver in
            return AcceptTaxTransactionUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: TaxTransferSendMoneyInputMapping.self) { resolver in
            return TaxTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: PLTransactionParametersProviderProtocol.self) { resolver in
            return PLTransactionParametersProvider(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: PLDomesticTransactionParametersGenerable.self) { _ in
            return PLDomesticTransactionParametersProvider()
        }
        
        dependenciesEngine.register(for: PenndingChallengeUseCaseProtocol.self) { resolver in
            return PenndingChallengeUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: NotifyDeviceUseCaseProtocol.self) { resolver in
            return NotifyDeviceUseCase(dependenciesResolver: resolver)
        }

        dependenciesEngine.register(for: TaxOperativeSummaryMapping.self) { _ in
            return TaxOperativeSummaryMapper()
        }
    }
}

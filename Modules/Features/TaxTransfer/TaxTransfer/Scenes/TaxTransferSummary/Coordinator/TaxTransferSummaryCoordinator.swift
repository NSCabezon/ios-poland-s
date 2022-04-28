//
//  TaxTransferSummaryCoordinator.swift
//  TaxTransfer
//
//  Created by 187831 on 21/03/2022.
//

import UI
import CoreFoundationLib

protocol TaxTransferSummaryCoordinatorProtocol {
    func goToGlobalPosition()
    func goToMakeAnotherPayment()
    func start()
}

final class TaxTransferSummaryCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let transferModel: TaxTransferModel
    private let summaryModel: TaxTransferSummary
    
    init(dependenciesResolver: DependenciesResolver,
         summaryModel: TaxTransferSummary,
         transferModel: TaxTransferModel,
         navigationController: UINavigationController?) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.transferModel = transferModel
        self.summaryModel = summaryModel
        self.setupDependencies()
    }
    
    func start() {
        let presenter = TaxTransferSummaryPresenter(
            dependenciesResolver: dependenciesEngine,
            transferModel: transferModel,
            summaryModel: summaryModel
        )
        let viewController = TaxTransferSummaryViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToMakeAnotherPayment() {
        if let taxTransferForm = navigationController?.viewControllers.reversed().first(where: { $0 is TaxTransferFormView }) {
            navigationController?.popToViewController(taxTransferForm, animated: true)
            (taxTransferForm as? TaxTransferFormView)?.clearForm()
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
}

extension TaxTransferSummaryCoordinator: TaxTransferSummaryCoordinatorProtocol {
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension TaxTransferSummaryCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: TaxTransferSummaryCoordinatorProtocol.self) { _ in
            return self
        }
    }
}

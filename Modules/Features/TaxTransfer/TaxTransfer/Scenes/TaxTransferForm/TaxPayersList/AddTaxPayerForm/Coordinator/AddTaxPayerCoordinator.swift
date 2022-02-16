//
//  AddTaxPayerFormCoordinator.swift
//  TaxTransfer
//
//  Created by 187831 on 02/02/2022.
//

import CoreFoundationLib

protocol AddTaxPayerFormCoordinatorProtocol {
    var navigationController: UINavigationController? { get }
    
    func back()
    func goToGlobalPosition()
}

final class AddTaxPayerFormCoordinator {
    weak var navigationController: UINavigationController?
    
    private let isEmptyTaxPayersList: Bool
    private let dependenciesEngine: DependenciesDefault
    
    init(dependenciesResolver: DependenciesResolver,
         taxPayers: [TaxPayer],
         navigationController: UINavigationController?) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.isEmptyTaxPayersList = taxPayers.isEmpty
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = AddTaxPayerFormPresenter(
            dependenciesResolver: dependenciesEngine,
            coordinator: self
        )
        let viewController = AddTaxPayerFormViewController(presenter: presenter)
        viewController.delegate = presenter
        presenter.view = viewController
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AddTaxPayerFormCoordinator: AddTaxPayerFormCoordinatorProtocol {
    func back() {
        if isEmptyTaxPayersList {
            backToForm()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func backToForm() {
        guard let formViewController = navigationController?.viewControllers.first(
            where: { $0 is TaxTransferFormViewController }
        ) else { return }
        navigationController?.popToViewController(formViewController, animated: true)
    }
}

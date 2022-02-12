//
//  TaxPayersListCoordinator.swift
//  TaxTransfer
//
//  Created by 187831 on 01/02/2022.
//

import CoreFoundationLib

protocol TaxPayersListCoordinatorProtocol {
    func back()
    func backToForm()
    func goToGlobalPosition()
    
    func showPayerIdentifiers(for: TaxPayer)
    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo)
}

final class TaxPayersListCoordinator {
    weak var navigationController: UINavigationController?
    
    private weak var taxPayerSelectorDelegate: TaxPayerSelectorDelegate?
    private let selectedTaxPayer: TaxPayer?
    private let dependenciesEngine: DependenciesDefault
    private let taxPayers: [TaxPayer]
    
    public init(
        dependenciesResolver: DependenciesResolver,
        taxPayers: [TaxPayer],
        taxPayerSelectorDelegate: TaxPayerSelectorDelegate?,
        selectedTaxPayer: TaxPayer?,
        navigationController: UINavigationController?
    ) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.taxPayers = taxPayers
        self.navigationController = navigationController
        self.selectedTaxPayer = selectedTaxPayer
        self.taxPayerSelectorDelegate = taxPayerSelectorDelegate
    }
    
    func start() {
        let mapper = dependenciesEngine.resolve(for: TaxPayerViewModelMapping.self)

        let presenter = TaxTransferPayersListPresenter(
            dependenciesResolver: dependenciesEngine,
            coordinator: self
        )
        let viewModel = TaxTransferPayersListViewModel(
            mapper: mapper,
            taxPayers: taxPayers
        )
        let viewController = TaxTransferPayersListViewController(
           presenter: presenter,
           viewModel: viewModel
        )
        
        presenter.view = viewController
        viewController.set(selectedTaxPayer: selectedTaxPayer)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TaxPayersListCoordinator: TaxPayersListCoordinatorProtocol {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func backToForm() {
        guard let formViewController = navigationController?.viewControllers.first(where: { $0 is TaxTransferFormViewController }) else { return }
        navigationController?.popToViewController(formViewController, animated: true)
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }

    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo) {
        taxPayerSelectorDelegate?.didSelectTaxPayer(taxPayer, selectedPayerInfo: selectedPayerInfo)
        backToForm()
    }
    
    func showPayerIdentifiers(for taxPayer: TaxPayer) {
        let presenter = TaxTransferPayerIdentifiersPresenter(
            dependenciesResolver: dependenciesEngine,
            coordinator: self
        )
        let viewModel = TaxTransferPayerIdentifiersViewModel(taxPayer: taxPayer)
        let viewController = TaxTransferPayerIdentifiersViewController(
            presenter: presenter,
            viewModel: viewModel
        )
        presenter.view = viewController
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func showTaxPayerSelector(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo) {
        taxPayerSelectorDelegate?.didSelectTaxPayer(taxPayer, selectedPayerInfo: selectedPayerInfo)
        backToForm()
    }
}

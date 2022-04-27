//
//  TaxPayersListCoordinator.swift
//  TaxTransfer
//
//  Created by 187831 on 01/02/2022.
//

import CoreFoundationLib
import PLScenes
import UI
import PLUI

protocol TaxPayersListDelegate: AnyObject {
    func didAddTaxPayer(_ taxPayer: TaxPayer)
}

protocol TaxPayersListCoordinatorProtocol {
    var navigationController: UINavigationController? { get }
    var delegate: TaxPayersListDelegate? { get set }
    
    func back()
    func backToForm()
    func goToGlobalPosition()
    
    func reload()
    func showAddPayerView()
    func showPayerIdentifiers(for: TaxPayer)
    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo?)
}

final class TaxPayersListCoordinator: ModuleCoordinator {
    weak var delegate: TaxPayersListDelegate?
    weak var navigationController: UINavigationController?
    
    private weak var taxPayerSelectorDelegate: TaxPayerSelectorDelegate?
    private let selectedTaxPayer: TaxPayer?
    private let dependenciesEngine: DependenciesDefault
    private var taxPayers: [TaxPayer]
    private let shouldBackAfterSelectItem = false
    private var coordinator: TaxTransferParticipantSelectorCoordinator<TaxTransferFormViewModel.TaxPayerViewModel>?
    
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
        guard !taxPayers.isEmpty else {
            showAddPayerView()
            return
        }

        if let selectedTaxPayer = selectedTaxPayer {
            showTaxItemSelector(with: mapper.map(selectedTaxPayer))
        } else {
            showTaxItemSelector(with: nil)
        }
    }
    
    private func handleSelectionItem(
        _ taxPayerViewModel: TaxTransferFormViewModel.TaxPayerViewModel,
        in presenter: (LoaderPresentable & ConfirmationDialogPresentable)
    ) {
        switch taxPayerViewModel.taxPayerSecondaryIdentifier {
        case .available:
            if taxPayerViewModel.hasDifferentTaxIdentifiers {
                showPayerIdentifiers(for: taxPayerViewModel.taxPayer)
            } else {
                didSelectTaxPayer(taxPayerViewModel.taxPayer, selectedPayerInfo: nil)
            }
        case .notAvailable:
            didSelectTaxPayer(taxPayerViewModel.taxPayer, selectedPayerInfo: nil)
        }
    }
    
    private func didTapButton() {
        showAddPayerView()
    }
    
    private func showTaxItemSelector(with selectedTaxPayer: TaxTransferFormViewModel.TaxPayerViewModel?) {
        let configuration = TaxTransferParticipantConfiguration<TaxTransferFormViewModel.TaxPayerViewModel>(
            shouldBackAfterSelectItem: shouldBackAfterSelectItem,
            taxItemSelectorType: .payer,
            items: mapper.map(taxPayers),
            selectedItem: selectedTaxPayer
        )
        let taxItemSelectorCoordinator = TaxTransferParticipantSelectorCoordinator<TaxTransferFormViewModel.TaxPayerViewModel>(
            configuration: configuration,
            itemSelectionHandler: handleSelectionItem,
            buttonActionHandler: didTapButton,
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController
        )
        self.coordinator = taxItemSelectorCoordinator
        taxItemSelectorCoordinator.start()
    }
}

extension TaxPayersListCoordinator: TaxPayersListCoordinatorProtocol {
    func reload() {
        if let selectedTaxPayer = selectedTaxPayer {
            let configuration = TaxTransferParticipantConfiguration<TaxTransferFormViewModel.TaxPayerViewModel>(
                shouldBackAfterSelectItem: shouldBackAfterSelectItem,
                taxItemSelectorType: .payer,
                items: mapper.map(taxPayers),
                selectedItem: mapper.map(selectedTaxPayer)
            )
            coordinator?.reload(with: configuration)
        } else {
            let configuration = TaxTransferParticipantConfiguration<TaxTransferFormViewModel.TaxPayerViewModel>(
                shouldBackAfterSelectItem: shouldBackAfterSelectItem,
                taxItemSelectorType: .payer,
                items: mapper.map(taxPayers),
                selectedItem: nil
            )
            coordinator?.reload(with: configuration)
        }
    }
    
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

    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo?) {
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
    
    func showTaxPayerSelector(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo) {
        taxPayerSelectorDelegate?.didSelectTaxPayer(taxPayer, selectedPayerInfo: selectedPayerInfo)
        backToForm()
    }
    
    func showAddPayerView() {
        let coordinator = AddTaxPayerFormCoordinator(
            dependenciesResolver: dependenciesEngine,
            taxPayers: taxPayers,
            coordinator: taxFormCoordinator,
            delegate: self,
            navigationController: navigationController
        )
        coordinator.start()
    }
}

extension TaxPayersListCoordinator: AddTaxPayerFormCoordinatorDelegate {
    func didAddTaxPayer(_ taxPayer: TaxPayer) {
        delegate?.didAddTaxPayer(taxPayer)
        reload()
    }
}

private extension TaxPayersListCoordinator {
    var mapper: TaxPayerViewModelMapping {
        dependenciesEngine.resolve()
    }
    
    var taxFormCoordinator: TaxTransferFormCoordinatorProtocol {
        dependenciesEngine.resolve()
    }
}

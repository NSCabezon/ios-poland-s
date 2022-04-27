//
//  AddTaxPayerFormCoordinator.swift
//  TaxTransfer
//
//  Created by 187831 on 02/02/2022.
//

import CoreFoundationLib
import PLScenes

protocol AddTaxPayerFormCoordinatorDelegate: AnyObject {
    func didAddTaxPayer(_ taxPayer: TaxPayer)
}

protocol AddTaxPayerFormCoordinatorProtocol {
    var navigationController: UINavigationController? { get }
    var delegate: AddTaxPayerFormCoordinatorDelegate? { get set }
    
    func back()
    func goToGlobalPosition()
    
    func didTapDone(with taxPayer: TaxPayer)
    func showIdentifiersSelectorView(
        with section: ItemSelectorConfiguration<TaxIdentifierType>.ItemSelectorSection,
        selectedItem: TaxIdentifierType?
    )
}

final class AddTaxPayerFormCoordinator {
    weak var navigationController: UINavigationController?
    weak var delegate: AddTaxPayerFormCoordinatorDelegate?
    
    private lazy var presenter = AddTaxPayerFormPresenter(
        dependenciesResolver: dependenciesEngine,
        coordinator: self
    )
    
    private let isEmptyTaxPayersList: Bool
    private let dependenciesEngine: DependenciesDefault
    private let coordinator: TaxTransferFormCoordinatorProtocol
    
    init(dependenciesResolver: DependenciesResolver,
         taxPayers: [TaxPayer],
         coordinator: TaxTransferFormCoordinatorProtocol,
         delegate: AddTaxPayerFormCoordinatorDelegate?,
         navigationController: UINavigationController?) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.isEmptyTaxPayersList = taxPayers.isEmpty
        self.navigationController = navigationController
        self.coordinator = coordinator
        self.delegate = delegate
        setUpDependencies()
    }
    
    func start() {
        let viewController = AddTaxPayerFormViewController(presenter: presenter)
        viewController.delegate = presenter
        presenter.view = viewController
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AddTaxPayerFormCoordinator: AddTaxPayerFormCoordinatorProtocol {
    func didTapDone(with taxPayer: TaxPayer) {
        delegate?.didAddTaxPayer(taxPayer)
        backToForm()
    }
    
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
    
    func showIdentifiersSelectorView(
        with section: ItemSelectorConfiguration<TaxIdentifierType>.ItemSelectorSection,
        selectedItem: TaxIdentifierType?
    ) {
        let configuration = ItemSelectorConfiguration<TaxIdentifierType>(
            navigationTitle: localized("pl_toolbar_title_chooseID"),
            searchMode: .disabled,
            sections: [section],
            selectedItem: selectedItem,
            shouldShowDialogBeforeClose: true
        )
        let coordinator = ItemSelectorCoordinator<TaxIdentifierType>(
            navigationController: navigationController,
            configuration: configuration,
            itemSelectionHandler: handleSelectedTaxIdentifier,
            dependenciesResolver: dependenciesEngine
        )
        coordinator.start()
    }
}

private extension AddTaxPayerFormCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: TaxIdentifierMapping.self) { _ in
            return TaxIdentifierMapper()
        }
    }
    
    func handleSelectedTaxIdentifier(item: TaxIdentifierType) {
        presenter.handleSelectedTaxIdentifier(item: item)
    }
    
    func backToForm() {
        guard let formViewController = navigationController?.viewControllers.first(
            where: { $0 is TaxTransferFormViewController }
        ) else { return }
        navigationController?.popToViewController(formViewController, animated: true)
    }
}

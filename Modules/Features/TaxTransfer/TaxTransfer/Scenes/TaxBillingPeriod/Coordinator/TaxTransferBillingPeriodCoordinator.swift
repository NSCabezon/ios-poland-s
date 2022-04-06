//
//  TaxTransferBillingPeriodCoordinator.swift
//  Transfer
//
//  Created by 187831 on 03/03/2022.
//

import CoreFoundationLib
import UI
import PLScenes

final class TaxTransferBillingPeriodCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    
    private weak var delegate: TaxBillingPeriodSelectorDelegate?
    private lazy var presenter = TaxTransferBillingPeriodPresenter(
        dependenciesResolver: dependenciesEngine
    )
    private let dependenciesEngine: DependenciesDefault
    
    init(dependenciesResolver: DependenciesResolver,
         delegate: TaxBillingPeriodSelectorDelegate?,
         navigationController: UINavigationController?) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.delegate = delegate
        self.navigationController = navigationController
        setUpDependencies()
    }
    
    func start() {
        let viewController = TaxTransferBillingPeriodViewController(
            presenter: presenter,
            delegate: presenter
        )
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSelector(
        with section: ItemSelectorConfiguration<TaxTransferBillingPeriodType>.ItemSelectorSection,
        title: String,
        selectedItem: TaxTransferBillingPeriodType?
    ) {
        let configuration = ItemSelectorConfiguration<TaxTransferBillingPeriodType>(
            navigationTitle: title,
            isSearchEnabled: false,
            sections: [section],
            selectedItem: selectedItem
        )
        let coordinator = ItemSelectorCoordinator<TaxTransferBillingPeriodType>(
            navigationController: navigationController,
            configuration: configuration,
            itemSelectionHandler: handleSelectedItem
        )
        coordinator.start()
    }
    
    func showSelector(
        with section: ItemSelectorConfiguration<Int>.ItemSelectorSection,
        title: String,
        selectedItem: Int?
    ) {
        let configuration = ItemSelectorConfiguration<Int>(
            navigationTitle: title,
            isSearchEnabled: false,
            sections: [section],
            selectedItem: selectedItem
        )
        let coordinator = ItemSelectorCoordinator<Int>(
            navigationController: navigationController,
            configuration: configuration,
            itemSelectionHandler: handleSelectedItem
        )
        coordinator.start()
    }
    
    func didTapDone(with form: TaxTransferBillingPeriodForm) {
        delegate?.didSelectTaxBillingPeriod(
            form: form
        )
        back()
    }
    
    func didPressBack() {
        back()
    }
    
    func didPressClose() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension TaxTransferBillingPeriodCoordinator {    
    func setUpDependencies() {
        dependenciesEngine.register(for: TaxTransferBillingPeriodCoordinator.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: TaxTransferBillingPeriodValidating.self) { _ in
            return TaxTransferBillingPeriodValidator()
        }
    }
    
    func handleSelectedItem(item: TaxTransferBillingPeriodType) {
         presenter.handleSelectedItem(item: item)
     }
    
    func handleSelectedItem(item: Int) {
        presenter.handleSelectedItem(item: item)
    }
    
    func back() {
        guard let formViewController = navigationController?.viewControllers.first(
            where: { $0 is TaxTransferFormViewController }
        ) else { return }
        navigationController?.popToViewController(formViewController, animated: true)
    }
}

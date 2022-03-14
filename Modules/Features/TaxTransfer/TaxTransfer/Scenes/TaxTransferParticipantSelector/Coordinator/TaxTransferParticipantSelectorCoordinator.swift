//
//  TaxItemSelectorCoordinator.swift
//  TaxTransfer
//
//  Created by 187831 on 10/02/2022.
//

import UI
import PLUI
import CoreFoundationLib
import PLScenes

final class TaxTransferParticipantSelectorCoordinator<Item: SelectableItem>: ModuleCoordinator {
    private lazy var mapper = dependenciesEngine.resolve(for: TaxTransferParticipantSelectorMapper<Item>.self)
    private let itemSelectionHandler: (Item) -> ()
    private let buttonActionHandler: () -> ()
    private let configuration: TaxTransferParticipantConfiguration<Item>
    private let dependenciesEngine: DependenciesDefault
    private var viewController: TaxTransferParticipantSelectorViewController<Item>?
    
    internal var navigationController: UINavigationController?
    
    init(configuration: TaxTransferParticipantConfiguration<Item>,
         itemSelectionHandler: @escaping (Item) -> (),
         buttonActionHandler: @escaping () -> (),
         dependenciesResolver: DependenciesDefault,
         navigationController: UINavigationController?) {
        self.configuration = configuration
        self.itemSelectionHandler = itemSelectionHandler
        self.buttonActionHandler = buttonActionHandler
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        setupDependencies()
    }
    
    func start() {
        let viewModel = mapper.map(configuration)
        let viewController = TaxTransferParticipantSelectorViewController<Item>(
            taxItemSelectorType: configuration.taxItemSelectorType,
            viewModel: viewModel,
            coordinator: self,
            confirmationDialogFactory: confirmationDialogFactory
        )
        viewController.delegate = self
        self.viewController = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func handleItemSelection(_ item: Item) {
        itemSelectionHandler(item)
        
        if configuration.shouldBackAfterSelectItem {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func reload(with configuration: TaxTransferParticipantConfiguration<Item>) {
        viewController?.set(viewModel: mapper.map(configuration))
        viewController?.reload()
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension TaxTransferParticipantSelectorCoordinator: TaxItemSelectorView {
    func didTapButton() {
        buttonActionHandler()
    }
}

private extension TaxTransferParticipantSelectorCoordinator {
    var confirmationDialogFactory: ConfirmationDialogProducing {
        return dependenciesEngine.resolve()
    }
    
    func setupDependencies() {
        dependenciesEngine.register(for: TaxTransferParticipantSelectorMapper<Item>.self) { _ in
            return TaxTransferParticipantSelectorMapper()
        }
    }
}

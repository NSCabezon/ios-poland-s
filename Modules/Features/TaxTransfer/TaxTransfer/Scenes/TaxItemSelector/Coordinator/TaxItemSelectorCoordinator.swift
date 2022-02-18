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

final class TaxItemSelectorCoordinator<Item: SelectableItem>: ModuleCoordinator {
    private let itemSelectionHandler: (Item) -> ()
    private let configuration: TaxItemSelectorConfiguration<Item>
    private let dependenciesResolver: DependenciesResolver
    
    internal var navigationController: UINavigationController?
    
    init(configuration: TaxItemSelectorConfiguration<Item>,
         itemSelectionHandler: @escaping (Item) -> (),
         dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?) {
        self.configuration = configuration
        self.itemSelectionHandler = itemSelectionHandler
        self.dependenciesResolver = dependenciesResolver
        self.navigationController = navigationController
    }
    
    func start() {
        let mapper = TaxItemSelectorViewModelMapper<Item>()
        let viewModel = mapper.map(configuration)
        let viewController = TaxItemSelectorViewController(
            taxItemSelectorType: configuration.taxItemSelectorType,
            viewModel: viewModel,
            coordinator: self,
            confirmationDialogFactory: confirmationDialogFactory
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func handleItemSelection(_ item: Item) {
        itemSelectionHandler(item)
        navigationController?.popViewController(animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension TaxItemSelectorCoordinator {
    var confirmationDialogFactory: ConfirmationDialogProducing {
        return dependenciesResolver.resolve()
    }
}

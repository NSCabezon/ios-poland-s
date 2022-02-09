//
//  ItemSelectorCoordinator.swift
//  PLUI
//
//  Created by 185167 on 04/02/2022.
//

import UI

public final class ItemSelectorCoordinator<Item>: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let viewModel: ItemSelectorViewModel<Item>
    private let itemSelectionHandler: (Item) -> ()
    
    public init(
        navigationController: UINavigationController?,
        viewModel: ItemSelectorViewModel<Item>,
        itemSelectionHandler: @escaping (Item) -> ()
    ) {
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.itemSelectionHandler = itemSelectionHandler
    }
    
    public func start() {
        let controller = ItemSelectorViewController(
            coordinator: self,
            viewModel: viewModel
        )
        navigationController?.pushViewController(controller, animated: true)
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

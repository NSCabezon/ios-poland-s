//
//  ItemSelectorCoordinator.swift
//  PLScenes
//
//  Created by 185167 on 04/02/2022.
//

import UI

public final class ItemSelectorCoordinator<Item: SelectableItem>: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let configuration: ItemSelectorConfiguration<Item>
    private let itemSelectionHandler: (Item) -> ()
    
    public init(
        navigationController: UINavigationController?,
        configuration: ItemSelectorConfiguration<Item>,
        itemSelectionHandler: @escaping (Item) -> ()
    ) {
        self.navigationController = navigationController
        self.configuration = configuration
        self.itemSelectionHandler = itemSelectionHandler
    }
    
    public func start() {
        let presenter = ItemSelectorPresenter(
            coordinator: self,
            configuration: configuration,
            viewModelMapper: SelectableItemSectionViewModelMapper<Item>()
        )
        let controller = ItemSelectorViewController(presenter: presenter)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleItemSelection(_ item: Item) {
        itemSelectionHandler(item)
        guard configuration.shouldPopControllerAfterSelection else { return }
        navigationController?.popViewController(animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
}

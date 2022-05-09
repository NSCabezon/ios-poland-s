//
//  ItemSelectorCoordinator.swift
//  PLScenes
//
//  Created by 185167 on 04/02/2022.
//

import UI
import CoreFoundationLib
import PLUI

public final class ItemSelectorCoordinator<Item: SelectableItem>: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let configuration: ItemSelectorConfiguration<Item>
    private let itemSelectionHandler: (Item) -> ()
    private let dependenciesResolver: DependenciesDefault
    
    public init(
        navigationController: UINavigationController?,
        configuration: ItemSelectorConfiguration<Item>,
        itemSelectionHandler: @escaping (Item) -> (),
        dependenciesResolver: DependenciesResolver
    ) {
        self.navigationController = navigationController
        self.configuration = configuration
        self.itemSelectionHandler = itemSelectionHandler
        self.dependenciesResolver = DependenciesDefault(father: dependenciesResolver)
        setUpDependencies()
    }
    
    public func start() {
        let presenter = ItemSelectorPresenter(
            coordinator: self,
            configuration: configuration,
            viewModelMapper: SelectableItemSectionViewModelMapper<Item>(),
            dependenciesResolver: dependenciesResolver
        )
        let controller = ItemSelectorViewController(presenter: presenter)
        presenter.view = controller
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
    
    private func setUpDependencies() {
        dependenciesResolver.register(for: ConfirmationDialogProducing.self) { _ in
            return ConfirmationDialogFactory()
        }
    }
}

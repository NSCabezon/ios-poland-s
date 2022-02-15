//
//  ChequesFactory.swift
//  Account
//
//  Created by Piotr Mielcarzewicz on 16/06/2021.
//

import CoreFoundationLib
import Foundation
import SANPLLibrary
import PLCommons

public protocol ChequesProducing {
    func create(coordinator: ChequesCoordinator) -> UIViewController
}

public final class ChequesFactory: ChequesProducing {
    private let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public func create(coordinator: ChequesCoordinator) -> UIViewController {
        return ChequesViewController(
            dropdownPresenter: DropdownViewController(),
            coordinator: coordinator,
            activeChequesController: createChequeListController(
                coordinator: coordinator,
                listType: .active
            ),
            archivedChequesController: createChequeListController(
                coordinator: coordinator,
                listType: .archived
            )
        )
    }
    
    private func createChequeListController(coordinator: ChequesCoordinator, listType: ChequeListType) -> UIViewController {
        let presenter = ChequeListPresenter(
            dependenciesResolver: dependenciesResolver,
            coordinator: coordinator,
            listType: listType,
            loadChequesUseCase:
                LoadChequesUseCase(
                    dependenciesResolver: dependenciesResolver
                )
            ,
            loadWalletParamsUseCase: LoadWalletParamsUseCase(
                dependenciesResolver: dependenciesResolver
            ),
            viewModelMapper: ChequeViewModelMapper(
                amountFormatter: .PLAmountNumberFormatter
            ),
            discardingLock: DiscardingLock()
        )
        let controller = ChequeListViewController(
            presenter: presenter,
            shouldShowCreateChequeButton: (listType == .active)
        )
        presenter.view = controller
        return controller
    }
}

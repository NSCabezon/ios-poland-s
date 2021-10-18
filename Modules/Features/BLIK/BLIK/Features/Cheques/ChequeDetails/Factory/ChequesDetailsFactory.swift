//
//  ChequesDetailsFactory.swift
//  BLIK
//
//  Created by 186491 on 21/06/2021.
//

import Commons
import SANPLLibrary
import PLUI

public protocol ChequesDetailsProducing {
    func create(coordinator: ChequesCoordinator, cheque: BlikCheque) -> UIViewController
}

public final class ChequesDetailsFactory: ChequesDetailsProducing {
    private let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public func create(coordinator: ChequesCoordinator, cheque: BlikCheque) -> UIViewController {
        let presenter = ChequeDetailsPresenter(
            dependenciesResolver: dependenciesResolver,
            coordinator: coordinator,
            cheque: cheque,
            removeUserCase: RemoveChequeUseCase(
                managersProvider: dependenciesResolver.resolve(
                    for: PLManagersProviderProtocol.self
                )
            ),
            viewModelMapper: ChequeDetailsViewModelMapper(
                amountFormatter: .PLAmountNumberFormatter
            )
        )
        let controller = ChequeDetailsViewController(
            presenter: presenter
        )
        presenter.view = controller
        return controller
    }
}

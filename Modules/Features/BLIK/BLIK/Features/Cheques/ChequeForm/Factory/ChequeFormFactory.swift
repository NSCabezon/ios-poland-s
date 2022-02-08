//
//  ChequeFormFactory.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 06/07/2021.
//

import CoreFoundationLib
import SANPLLibrary

public protocol ChequeFormProducing {
    func create(
        coordinator: ChequesCoordinatorProtocol,
        maxChequeAmount: Decimal
    ) -> UIViewController
}

public final class ChequeFormFactory: ChequeFormProducing {
    private let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public func create(
        coordinator: ChequesCoordinatorProtocol,
        maxChequeAmount: Decimal
    ) -> UIViewController {
        let currency = "PLN" // TODO:- Replace hardcoded currency with the one from API
        let amountFormatter: NumberFormatter = .PLAmountNumberFormatter
        amountFormatter.currencySymbol = currency
        let amountLimitWithCurrency = amountFormatter.string(for: maxChequeAmount) ?? "\(maxChequeAmount) \(currency)"
        let presenter = ChequeFormPresenter(
            dependenciesResolver: dependenciesResolver,
            validator: ChequeFormValidator(
                amountLimit: maxChequeAmount,
                currency: currency,
                amountFormatter: amountFormatter
            ),
            coordinator: coordinator,
            createChequeUseCase: CreateChequeUseCase(
                dependenciesResolver: dependenciesResolver
            ),
            amountLimit: amountLimitWithCurrency,
            currency: currency
        )
        let controller = ChequeFormViewController(
            presenter: presenter
        )
        presenter.view = controller
        return controller
    }
}

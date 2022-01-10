//
//  TaxTransferFormCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 01/12/2021.
//

import UI
import CoreFoundationLib
import Commons
import PLCommons
import SANPLLibrary

public protocol TaxTransferFormCoordinatorProtocol: ModuleCoordinator {
    func back()
}

public final class TaxTransferFormCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        setUpDependencies()
    }
    
    public func start() {
        var presenter = dependenciesEngine.resolve(for: TaxTransferFormPresenterProtocol.self)
        let controller = TaxTransferFormViewController(presenter: presenter)
        presenter.view = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension TaxTransferFormCoordinator: TaxTransferFormCoordinatorProtocol {
    public func back() {
        navigationController?.popViewController(animated: true)
    }
}

private extension TaxTransferFormCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: TaxTransferFormCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: TaxTransferFormPresenterProtocol.self) { resolver in
            return TaxTransferFormPresenter(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: TaxFormConfiguration.self) { resolver in
            return TaxFormConfiguration(
                amountField: .init(
                    amountFormatter: .PLAmountNumberFormatterWithoutCurrency
                ),
                dateSelector: .init(
                    language: resolver.resolve(for: StringLoader.self).getCurrentLanguage().appLanguageCode,
                    dateFormatter: PLTimeFormat.ddMMyyyyDotted.createDateFormatter()
                )
            )
        }
        
        dependenciesEngine.register(for: TaxTransferFormValidating.self) { _ in
            return TaxTransferFormValidator()
        }
    }
}

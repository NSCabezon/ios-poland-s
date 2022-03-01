//
//  SendMoneyTransferTypeStep.swift
//  Santander
//
//  Created by José Norberto Hidalgo Romero on 6/10/21.
//

import CoreFoundationLib
import Operative
import TransferOperatives

final class SendMoneyTransferTypeStep: OperativeStep {
    private let legacyDependenciesInjector: DependenciesInjector
    private let legacyDependenciesResolver: DependenciesResolver
    
    var presentationType: OperativeStepPresentationType {
        return .inNavigation(showsBack: true, showsCancel: true)
    }
    var view: OperativeView? {
        self.legacyDependenciesResolver.resolve(for: SendMoneyTransferTypeView.self)
    }
    
    var floatingButtonTitleKey = "sendMoney_button_sendType"
    
    init(legacyDependenciesResolver: DependenciesResolver) {
        let legacyDependencies = DependenciesDefault(father: legacyDependenciesResolver)
        self.legacyDependenciesInjector = legacyDependencies
        self.legacyDependenciesResolver = legacyDependencies
        setup(dependencies: legacyDependencies)
    }
    
    private func setup(dependencies: DependenciesInjector) {
        self.legacyDependenciesInjector.register(for: SendMoneyTransferTypePresenterProtocol.self) { resolver in
            return SendMoneyTransferTypePresenter(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: SendMoneyTransferTypeView.self) { resolver in
            let presenter = resolver.resolve(for: SendMoneyTransferTypePresenterProtocol.self)
            let viewController = SendMoneyTransferTypeViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

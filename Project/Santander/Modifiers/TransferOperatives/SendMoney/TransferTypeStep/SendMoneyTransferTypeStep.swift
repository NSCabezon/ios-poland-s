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
    let dependencies: DependenciesResolver & DependenciesInjector
    var presentationType: OperativeStepPresentationType {
        return .inNavigation(showsBack: true, showsCancel: true)
    }
    var view: OperativeView? {
        self.dependencies.resolve(for: SendMoneyTransferTypeView.self)
    }
    
    var floatingButtonTitleKey = "sendMoney_button_sendType"
    
    init(dependencies: DependenciesResolver & DependenciesInjector) {
        self.dependencies = dependencies
        setup(dependencies: dependencies)
    }
    
    private func setup(dependencies: DependenciesResolver & DependenciesInjector) {
        self.dependencies.register(for: SendMoneyTransferTypePresenterProtocol.self) { dependenciesResolver in
            return SendMoneyTransferTypePresenter(dependenciesResolver: dependenciesResolver)
        }
        self.dependencies.register(for: SendMoneyTransferTypeView.self) { dependenciesResolver in
            let presenter = dependenciesResolver.resolve(for: SendMoneyTransferTypePresenterProtocol.self)
            let viewController = SendMoneyTransferTypeViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

//
//  SendMoneyOperativeModifier.swift
//  Santander
//
//  Created by José Norberto Hidalgo Romero on 6/10/21.
//

import Commons
import Operative
import TransferOperatives

final class SendMoneyOperativeModifier {
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
    }
}

extension SendMoneyOperativeModifier: SendMoneyOperativeModifierProtocol {
    var transferTypeStep: OperativeStep? {
        return SendMoneyTransferTypeStep(dependencies: dependenciesEngine)
    }
}

final class SendMoneyTransferTypeStep: OperativeStep {
    let dependencies: DependenciesResolver & DependenciesInjector
    var presentationType: OperativeStepPresentationType {
        return .inNavigation(showsBack: true, showsCancel: true)
    }
    var view: OperativeView? {
        self.dependencies.resolve(for: SendMoneyTransferTypeView.self)
    }
    
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

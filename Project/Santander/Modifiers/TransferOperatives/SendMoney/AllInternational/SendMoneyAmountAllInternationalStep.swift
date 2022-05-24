//
//  SendMoneyAllInternationalStep.swift
//  Santander
//
//  Created by José María Jiménez Pérez on 28/4/22.
//

import Operative
import CoreFoundationLib

final class SendMoneyAmountAllInternationalStep: OperativeStep {
    private let legacyDependenciesResolver: DependenciesResolver
    private let legacyDependenciesInjector: DependenciesInjector
    
    init(legacyDependenciesResolver: DependenciesResolver) {
        let legacyDependencies = DependenciesDefault(father: legacyDependenciesResolver)
        self.legacyDependenciesResolver = legacyDependencies
        self.legacyDependenciesInjector = legacyDependencies
        self.setup()
    }
    var presentationType: OperativeStepPresentationType {
        return .inNavigation(showsBack: true, showsCancel: true)
    }
    var view: OperativeView? {
        self.legacyDependenciesResolver.resolve(for: SendMoneyAmountAllInternationalView.self)
    }
    var floatingButtonTitleKey: String {
        return "sendMoney_button_amountAndDate"
    }
}

private extension SendMoneyAmountAllInternationalStep {
    func setup() {
        self.legacyDependenciesInjector.register(for: SendMoneyAmountAllInternationalPresenterProtocol.self) { dependenciesResolver in
            return SendMoneyAmountAllInternationalPresenter(dependenciesResolver: dependenciesResolver)
        }
        self.legacyDependenciesInjector.register(for: SendMoneyAmountAllInternationalView.self) { dependenciesResolver in
            let presenter = dependenciesResolver.resolve(for: SendMoneyAmountAllInternationalPresenterProtocol.self)
            let viewController = SendMoneyAmountAllInternationalViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

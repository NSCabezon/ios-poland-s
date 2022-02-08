//
//  CreditCardChooseListViewMock.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 15/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import CoreFoundationLib
@testable import CreditCardRepayment
import Operative

final class CreditCardChooseListViewMock: CreditCardChooseListViewProtocol {
    var associatedViewController = UIViewController()
    var operativePresenter: OperativeStepPresenterProtocol
    var title: String?
    var associatedOldDialogView = UIViewController()
    var progressBarBackgroundColor: UIColor = .clear
    
    var onSetupWithCreditCards: (([CreditCardChooseListViewModel]) -> Void)?
    var onShowError: (() -> Void)?

    init(dependenciesResolver: DependenciesResolver) {
        self.operativePresenter = dependenciesResolver.resolve(for: CreditCardChooseListPresenterProtocol.self)
    }
    
    func setup(with creditCards: [CreditCardChooseListViewModel]) {
        onSetupWithCreditCards?(creditCards)
    }
    
    func showError(closeAction: (() -> Void)?) {
        onShowError?()
    }
}

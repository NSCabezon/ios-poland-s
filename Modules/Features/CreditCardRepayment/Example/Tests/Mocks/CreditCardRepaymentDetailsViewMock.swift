//
//  CreditCardRepaymentDetailsViewMock.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 27/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Commons
@testable import CreditCardRepayment
import Operative

final class CreditCardRepaymentDetailsViewMock: CreditCardRepaymentDetailsViewProtocol {
    // Operative
    var associatedOldDialogView: UIViewController = UIViewController()
    var progressBarBackgroundColor: UIColor = .clear
    var associatedViewController: UIViewController = UIViewController()
    var operativePresenter: OperativeStepPresenterProtocol
    var title: String?
    
    // Mock
    var editHeaderViewModel: CreditCardRepaymentDetailsEditHeaderViewModel?
    var accountInfoViewModel: CreditCardRepaymentDetailsAccountInfoViewModel?
    var repaymentTypeInfoViewModel: CreditCardRepaymentDetailsRepaymentTypeInfoViewModel?
    var repaymentAmountViewModel: CreditCardRepaymentDetailsRepaymentAmountViewModel?
    var dateInfoViewModel: CreditCardRepaymentDateInfoViewModel?
    var nextViewModel: CreditCardRepaymentDetailsNextViewModel?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.operativePresenter = dependenciesResolver.resolve(for: CreditCardRepaymentDetailsPresenterProtocol.self)
    }
    
    func setupEditHeader(with viewModel: CreditCardRepaymentDetailsEditHeaderViewModel) {
        editHeaderViewModel = viewModel
    }

    func setupAccountTypeInfo(with viewModel: CreditCardRepaymentDetailsAccountInfoViewModel) {
        accountInfoViewModel = viewModel
    }
    
    func setupRepaymentTypeInfo(with viewModel: CreditCardRepaymentDetailsRepaymentTypeInfoViewModel) {
        repaymentTypeInfoViewModel = viewModel
    }
    
    func setupRepaymentAmount(with viewModel: CreditCardRepaymentDetailsRepaymentAmountViewModel) {
        repaymentAmountViewModel = viewModel
    }
    
    func setupDateInfo(with viewModel: CreditCardRepaymentDateInfoViewModel) {
        dateInfoViewModel = viewModel
    }
    
    func setupNext(with viewModel: CreditCardRepaymentDetailsNextViewModel) {
        nextViewModel = viewModel
    }
    
    func showMinimumAmountDialog() {}
    func showConfirmAbandonChangesDialog(onAccept: @escaping () -> Void) {}
}


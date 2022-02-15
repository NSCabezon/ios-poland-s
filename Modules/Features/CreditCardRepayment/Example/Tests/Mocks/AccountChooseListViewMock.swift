//
//  AccountChooseListViewMock.swift
//  CreditCardRepayment
//
//  Created by 186484 on 19/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import CoreFoundationLib
import Operative
@testable import CreditCardRepayment

final class AccountChooseListViewMock: AccountChooseListViewProtocol {
    var associatedGenericErrorDialogView = UIViewController()

    var onSetupWithAccounts: (([AccountChooseListViewModel]) -> Void)?
    var onShowError: (() -> Void)?

    func setup(with accounts: [AccountChooseListViewModel]) {
        onSetupWithAccounts?(accounts)
    }
    
    func showError(closeAction: (() -> Void)?) {
        onShowError?()
    }

}

//
//  TaxTransferFormCoordinatorMock.swift
//  TaxTransfer_Tests
//
//  Created by 185167 on 17/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import PLCommons
import PLUI
@testable import TaxTransfer

final class TaxTransferFormCoordinatorMock: TaxTransferFormCoordinatorProtocol {
    var navigationController: UINavigationController?
    
    var startBlock: () -> Void = {
        XCTFail("Empty implementation")
    }
    
    var showAccountSelectorBlock: ([AccountForDebit], String?, AccountForDebitSelectorMode) -> Void = { (_, _, _) in
        XCTFail("Empty implementation")
    }
    
    var backBlock: () -> Void = {
        XCTFail("Empty implementation")
    }
    
    func start() {
        startBlock()
    }
    
    func showAccountSelector(with accounts: [AccountForDebit], selectedAccountNumber: String?, mode: AccountForDebitSelectorMode) {
        showAccountSelectorBlock(accounts, selectedAccountNumber, mode)
    }
    
    func back() {
        backBlock()
    }
}

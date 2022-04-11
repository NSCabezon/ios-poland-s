//
//  MockPhoneTopUpCoordinator.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 11/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PLCommons
@testable import PhoneTopUp

final class MockPhoneTopUpFormCoordinator: PhoneTopUpFormCoordinatorProtocol {
    
    var backCallCount = 0
    var closeCallCount = 0
    var didSelectChangeAccountCallCount = 0
    var showInternetContactsCallcount = 0
    var showPhoneContactsCallCount = 0
    var showTopUpConfirmationCallCount = 0
    var showOperatorSelectionCallCount = 0
    
    func back() {
        backCallCount += 1
    }
    
    func close() {
        closeCallCount += 1
    }
    
    func didSelectChangeAccount(availableAccounts: [AccountForDebit], selectedAccountNumber: String?) {
        didSelectChangeAccountCallCount += 1
    }
    
    func showInternetContacts() {
        showInternetContactsCallcount += 1
    }
    
    func showPhoneContacts(_ contacts: [MobileContact]) {
        showPhoneContactsCallCount += 1
    }
    
    func showTopUpConfirmation(with summary: TopUpModel) {
        showTopUpConfirmationCallCount += 1
    }
    
    func showOperatorSelection(currentlySelectedOperatorId operatorId: Int?) {
        showOperatorSelectionCallCount += 1
    }
}

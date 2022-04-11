//
//  MockPhoneTopUpFormView.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 11/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PLCommons
import UI
import PLUI
@testable import PhoneTopUp

final class MockPhoneTopUpFormView: PhoneTopUpFormViewProtocol {
    
    var associatedLoadingView = UIViewController()
    var updateSelectedAccountCallCount = 0
    var updatePhoneInputCallCount = 0
    var updateRecipientNameCallCount = 0
    var updateContactCallCount = 0
    var updateOperatorSelectionCallCount = 0
    var updatePaymentAmountsCallCount = 0
    var updateTermsViewCallCount = 0
    var updateContinueButtonCallCount = 0
    var showInvalidPhoneNumberErrorCallCount = 0
    var showInvalidCustomAmountErrorCallCount = 0
    var showContactsPermissionsDeniedDialogCallCount = 0
    var showDialogCallCount = 0
    var showLoaderCallCount = 0
    var hideLoaderCallCount = 0
    var showErrorDialogCallCount = 0
    
    func updateSelectedAccount(with accountModels: [SelectableAccountViewModel]) {
        updateSelectedAccountCallCount += 1
    }
    
    func updatePhoneInput(with phoneNumber: String) {
        updatePhoneInputCallCount += 1
    }
    
    func updateRecipientName(with name: String) {
        updateRecipientNameCallCount += 1
    }
    
    func updateContact(with contact: MobileContact) {
        updateContactCallCount += 1
    }
    
    func updateOperatorSelection(with gsmOperator: Operator?) {
        updateOperatorSelectionCallCount += 1
    }
    
    func updatePaymentAmounts(with cellModels: [PaymentAmountCellViewModel], selectedAmount: TopUpAmount?) {
        updatePaymentAmountsCallCount += 1
    }
    
    func updateTermsView(isAcceptanceRequired: Bool, isAccepted: Bool) {
        updateTermsViewCallCount += 1
    }
    
    func updateContinueButton(isEnabled: Bool) {
        updateContinueButtonCallCount += 1
    }
    
    func showInvalidPhoneNumberError(_ showError: Bool) {
        showInvalidPhoneNumberErrorCallCount += 1
    }
    
    func showInvalidCustomAmountError(_ error: String?) {
        showInvalidCustomAmountErrorCallCount += 1
    }
    
    func showContactsPermissionsDeniedDialog() {
        showContactsPermissionsDeniedDialogCallCount += 1
    }
    
    func showDialog(_ dialog: LisboaDialog) {
        showDialogCallCount += 1
    }
    
    func showLoader() {
        showLoaderCallCount += 1
    }
    
    func hideLoader(completion: (() -> Void)?) {
        hideLoaderCallCount += 1
        completion?()
    }
    
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {
        showErrorDialogCallCount += 1
        onConfirm?()
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {
        showErrorDialogCallCount += 1
        onConfirm?()
    }
    
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {
        showErrorDialogCallCount += 1
        onConfirm?()
    }
    
    func showErrorMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?) {
        showErrorDialogCallCount += 1
        onConfirm?()
    }
    
    func showErrorMessage(title: String, message: String, actionButtonTitle: String, closeButton: Dialog.CloseButton, onConfirm: (() -> Void)?) {
        showErrorDialogCallCount += 1
        onConfirm?()
    }
}

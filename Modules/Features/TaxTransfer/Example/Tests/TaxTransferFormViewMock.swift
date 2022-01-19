//
//  TaxTransferFormViewMock.swift
//  TaxTransfer_Tests
//
//  Created by 185167 on 17/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import UI
import PLUI
@testable import TaxTransfer

final class TaxTransferFormViewMock: TaxTransferFormView, ErrorPresentable, LoaderPresentable {
    var setViewModelBlock: (TaxTransferFormViewModel) -> Void = { _ in
        XCTFail("Empty implementation")
    }
    
    var disableDoneButtionBlock: (TaxTransferFormValidity.InvalidFormMessages) -> Void = { _ in
        XCTFail("Empty implementation")
    }
    
    var enableDoneButtonBlock: () -> Void = {
        XCTFail("Empty implementation")
    }
    
    var getCurrentFormDataBlock: () -> TaxTransferFormFieldsData = { () -> TaxTransferFormFieldsData in
        XCTFail("Empty implementation")
        return TaxTransferFormFieldsData(
            amount: "",
            obligationIdentifier: "",
            date: Date()
        )
    }
    
    func setViewModel(_ viewModel: TaxTransferFormViewModel) {
        setViewModelBlock(viewModel)
    }
    
    func disableDoneButton(with messages: TaxTransferFormValidity.InvalidFormMessages) {
        disableDoneButtionBlock(messages)
    }
    
    func enableDoneButton() {
        enableDoneButtonBlock()
    }
    
    func getCurrentFormData() -> TaxTransferFormFieldsData {
        return getCurrentFormDataBlock()
    }
}

extension TaxTransferFormView  {
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {
        XCTFail("Empty implementation")
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {
        XCTFail("Empty implementation")
    }
    
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {
        XCTFail("Empty implementation")
    }
    
    func showErrorMessage(
        title: String,
        message: String,
        actionButtonTitle: String,
        closeButton: Dialog.CloseButton,
        onConfirm: (() -> Void)?
    ) {
        XCTFail("Empty implementation")
    }
    
    func showLoader() {
        XCTFail("Empty implementation")
    }
    
    func hideLoader(completion: (() -> Void)?) {
        XCTFail("Empty implementation")
    }
}

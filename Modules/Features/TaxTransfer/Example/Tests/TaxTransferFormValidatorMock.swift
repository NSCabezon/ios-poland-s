//
//  TaxTransferFormValidatorMock.swift
//  TaxTransfer_Tests
//
//  Created by 185167 on 17/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
@testable import TaxTransfer

final class TaxTransferFormValidatorMock: TaxTransferFormValidating {
    var validationBlock: (TaxTransferFormFields) -> TaxTransferFormValidity = { _ -> TaxTransferFormValidity in
        XCTFail("Empty implementation")
        return .valid
    }
    
    func validateFields(_ data: TaxTransferFormFields) -> TaxTransferFormValidity {
        return validationBlock(data)
    }
}

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
    var validationBlock: (TaxTransferFormFieldsData) -> TaxTransferFormValidity = { _ -> TaxTransferFormValidity in
        XCTFail("Empty implementation")
        return .valid
    }
    
    func validateData(_ data: TaxTransferFormFieldsData) -> TaxTransferFormValidity {
        return validationBlock(data)
    }
}

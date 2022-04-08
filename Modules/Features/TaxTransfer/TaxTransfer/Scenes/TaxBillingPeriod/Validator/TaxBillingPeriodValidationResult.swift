//
//  TaxBillingPeriodValidationResult.swift
//  TaxTransfer
//
//  Created by 187831 on 10/03/2022.
//

enum TaxBillingPeriodValidationResult {
    case valid
    case invalid(InvalidTaxBillingPeriodFormMessage)
}

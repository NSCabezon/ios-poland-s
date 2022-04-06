//
//  TaxTransferBillingPeriodValidator.swift
//  TaxTransfer
//
//  Created by 187831 on 10/03/2022.
//

import CoreFoundationLib

protocol TaxTransferBillingPeriodValidating {
    func validate(_ form: TaxTransferBillingPeriodForm) -> TaxBillingPeriodValidationResult
}

final class TaxTransferBillingPeriodValidator: TaxTransferBillingPeriodValidating {
    func validate(_ form: TaxTransferBillingPeriodForm) -> TaxBillingPeriodValidationResult {
        let invalidYearMesssage = getValidation(for: form.year)
        let invalidDayMessage = getValidation(for: form.day ?? "")
        
        if invalidYearMesssage == nil && invalidDayMessage == nil {
            return .valid
        } else {
            if form.periodType != .day, invalidYearMesssage == nil {
                return .valid
            }
            return .invalid(.init(invalidYearMessage: invalidYearMesssage, invalidDayMessage: invalidDayMessage))
        }
    }
    
    private func getValidation(for value: String) -> String? {
        guard !value.isEmpty else {
            return ""
        }
        
        if value.count == 4 {
            return nil
        } else {
            return localized("#Pole nie może być puste")
        }
    }
}
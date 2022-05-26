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
        let invalidYearMesssage = getValidation(for: form.year, periodType: .year)
        let invalidDayMessage = getValidation(for: form.day ?? "", periodType: .day)

        if invalidYearMesssage == nil && invalidDayMessage == nil, form.periodType != nil {
            return .valid
        } else if invalidYearMesssage == nil, form.periodType != nil, form.periodNumber != nil  {
            return .valid
        } else if form.periodType == .year, invalidYearMesssage == nil {
            return .valid
        } else {
            return .invalid(.init(invalidYearMessage: invalidYearMesssage, invalidDayMessage: invalidDayMessage))
        }
    }
    
    private func getValidation(for value: String, periodType: TaxTransferBillingPeriodType?) -> String? {
        guard value.count >= 1 else {
            return getErrorMessage(periodType: periodType)
        }
        return nil
    }
    
    private func getErrorMessage(periodType: TaxTransferBillingPeriodType?) -> String {
        if periodType != .day {
            return localized("pl_generic_validationText_thisFieldCannotBeEmpty")
        } else {
            return localized("pl_taxTransfer_validation_periodNumberDdMm")
        }
    }
}

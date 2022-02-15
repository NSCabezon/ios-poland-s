//
//  CustomTopUpAmountValidator.swift
//  PhoneTopUp
//
//  Created by 188216 on 09/02/2022.
//

import CoreFoundationLib
import Foundation
import PLCommons

enum CustomTopUpAmountValidationResult {
    case valid
    case error(String)
}

protocol CustomTopUpAmountValidating {
    func validate(amount: TopUpAmount?, minAmount: Int?, maxAmount: Int?, availableFunds: Decimal?) -> CustomTopUpAmountValidationResult
}

final class CustomTopUpAmountValidator: CustomTopUpAmountValidating {
    func validate(amount: TopUpAmount?, minAmount: Int?, maxAmount: Int?, availableFunds: Decimal?) -> CustomTopUpAmountValidationResult {
        if case .custom(let amount) = amount {
            guard let amount = amount else {
                return .error("")
            }
            guard let minAmount = minAmount, let maxAmount = maxAmount, let availableFunds = availableFunds else {
                return .error(localized("pl_topup_text_valid_fundsNoAvailb"))
            }
            
            guard amount >= minAmount else {
                return .error(localized("pl_topup_text_valid_minFund", [StringPlaceholder(.value, "\(minAmount)")]).text)
            }
            
            guard amount <= maxAmount else {
                return .error(localized("pl_topup_text_valid_maxFund", [StringPlaceholder(.value, "\(maxAmount)")]).text)
            }
            
            guard Decimal(amount) <= availableFunds else {
                return .error(localized("pl_topup_text_valid_fundsNoAvailb"))
            }
            
            return .valid
        }
        return .valid
    }
}

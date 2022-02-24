//
//  TopUpFormValidator.swift
//  PhoneTopUp
//
//  Created by 188216 on 16/02/2022.
//

import Foundation
import PLCommons

protocol TopUpFormValidating {
    func areFormInputsValid(account: AccountForDebit?,
                      number: TopUpPhoneNumber,
                      gsmOperator: GSMOperator?,
                      operator: Operator?,
                      topUpAmount: TopUpAmount?,
                      termsAcceptanceRequired: Bool,
                      termsAccepted: Bool) -> Bool
}

final class TopUpFormValidator: TopUpFormValidating {
    
    private let customAmountValidator: CustomTopUpAmountValidating
    private let numberValidator: PartialPhoneNumberValidating
    
    init(customAmountValidator: CustomTopUpAmountValidating, numberValidator: PartialPhoneNumberValidating) {
        self.customAmountValidator = customAmountValidator
        self.numberValidator = numberValidator
    }
    
    func areFormInputsValid(account: AccountForDebit?,
                      number: TopUpPhoneNumber,
                      gsmOperator: GSMOperator?,
                      operator: Operator?,
                      topUpAmount: TopUpAmount?,
                      termsAcceptanceRequired: Bool,
                      termsAccepted: Bool) -> Bool {
        guard let account = account,
              let _ = gsmOperator,
              let mobileOperator = `operator`,
              let topUpAmount = topUpAmount else {
            return false
        }
        
        if termsAcceptanceRequired, termsAccepted == false {
            return false
        }
        
        let numberValidationResults = numberValidator.validatePhoneNumberText(number.number)
        
        guard case .valid = numberValidationResults else {
            return false
        }
        
        let customAmountValidationResults = customAmountValidator.validate(amount: topUpAmount,
                                                                           minAmount: mobileOperator.topupValues.min,
                                                                           maxAmount: mobileOperator.topupValues.max,
                                                                           availableFunds: account.availableFunds.amount)
        
        guard case .valid = customAmountValidationResults else {
            return false
        }
        
        return true
    }
}

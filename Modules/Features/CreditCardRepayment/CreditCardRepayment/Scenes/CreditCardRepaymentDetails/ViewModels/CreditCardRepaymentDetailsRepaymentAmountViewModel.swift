//
//  CreditCardRepaymentDetailsRepaymentAmountViewModel.swift
//  CreditCardRepayment
//
//  Created by 186490 on 11/06/2021.
//

import Foundation

struct CreditCardRepaymentDetailsRepaymentAmountViewModel {
    let initialText: String?
    let placeholder: String
    let currency: String
    let canEdit: Bool
    var errorMessage: String? = nil
    var didChange: ((String) -> Void)? = nil
}

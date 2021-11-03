//
//  CreditCardRepaymentDateInfoViewModel.swift
//  CreditCardRepayment
//
//  Created by 186490 on 14/06/2021.
//

import Foundation

struct CreditCardRepaymentDateInfoViewModel {
    let text: String
    let date: Date
    var didEndEditing: ((Date) -> Void)? = nil
}

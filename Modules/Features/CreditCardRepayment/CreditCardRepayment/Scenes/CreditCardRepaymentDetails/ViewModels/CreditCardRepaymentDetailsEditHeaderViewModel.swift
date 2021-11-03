//
//  CreditCardRepaymentDetailsEditHeaderViewModel.swift
//  CreditCardRepayment
//
//  Created by 186484 on 24/06/2021.
//

import Foundation

struct CreditCardRepaymentDetailsEditHeaderViewModel {
    let title: String
    let description: String
    let isEditVisible: Bool
    let tapAction: (() -> Void)?
}

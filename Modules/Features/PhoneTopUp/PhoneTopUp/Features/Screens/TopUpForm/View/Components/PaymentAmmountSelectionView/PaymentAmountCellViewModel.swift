//
//  PaymentAmountCellViewModel.swift
//  PhoneTopUp
//
//  Created by 188216 on 08/02/2022.
//

import Foundation

enum PaymentAmountCellViewModel {
    case fixed(value: TopUpValue, isSelected: Bool)
    case custom(min: Int, max: Int, isSelected: Bool)
}

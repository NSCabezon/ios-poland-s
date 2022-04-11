//
//  PaymentAmountCellViewModelMapper.swift
//  PhoneTopUp
//
//  Created by 188216 on 11/02/2022.
//

import Foundation

protocol PaymentAmountCellViewModelMapping {
    func map(topUpValues: TopUpValues?, selectedAmount: TopUpAmount?) -> [PaymentAmountCellViewModel]
}

final class PaymentAmountCellViewModelMapper: PaymentAmountCellViewModelMapping {
    func map(topUpValues topUp: TopUpValues?, selectedAmount: TopUpAmount?) -> [PaymentAmountCellViewModel] {
        guard let topUp = topUp else {
            return []
        }
        var cellModels = topUp.values.map({ topUpValue -> PaymentAmountCellViewModel in
            var isSelected = false
            if case .fixed(let selectedTopUpValue) = selectedAmount, selectedTopUpValue == topUpValue {
                isSelected = true
            }
            return PaymentAmountCellViewModel.fixed(value: topUpValue, isSelected: isSelected)
        })
        
        if let maxAmount = topUp.max, let minAmount = topUp.min, topUp.customAmountEnabled {
            var isSelected = false
            if case .custom = selectedAmount {
                isSelected = true
            }
            cellModels.append(.custom(min: minAmount, max: maxAmount, isSelected: isSelected))
        }
        
        return cellModels
    }
}

//
//  OperatorSelectionCellViewModel.swift
//  PhoneTopUp
//
//  Created by 188216 on 21/01/2022.
//

import Foundation

struct OperatorSelectionCellViewModel {
    // MARK: Properties
    
    let operatorId: Int
    let operatorName: String
    let isSelected: Bool
    
    // MARK: Lifecycle
    
    init(operatorId: Int, operatorName: String, isSelected: Bool) {
        self.operatorId = operatorId
        self.operatorName = operatorName
        self.isSelected = isSelected
    }
    
    init(gsmOperator: GSMOperator, isSelected: Bool) {
        self.operatorId = gsmOperator.id
        self.operatorName = gsmOperator.name
        self.isSelected = isSelected
    }
}

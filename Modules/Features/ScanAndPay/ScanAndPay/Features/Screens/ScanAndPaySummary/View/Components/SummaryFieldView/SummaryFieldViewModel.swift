//
//  SummaryFieldViewModel.swift
//  ScanAndPay
//
//  Created by 188216 on 12/04/2022.
//

import Foundation

struct SummaryFieldViewModel {
    let title: String
    let value: String
    let isValueBold: Bool
    let showSeparator: Bool
    
    init(title: String, value: String, isValueBold: Bool = false, showSeparator: Bool = true) {
        self.title = title
        self.value = value
        self.isValueBold = isValueBold
        self.showSeparator = showSeparator
    }
}

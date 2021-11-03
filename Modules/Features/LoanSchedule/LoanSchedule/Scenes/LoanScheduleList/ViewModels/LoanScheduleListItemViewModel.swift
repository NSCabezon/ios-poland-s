//
//  LoanScheduleListItemViewModel.swift
//  LoanSchedule
//
//  Created by 186490 on 02/09/2021.
//

import Foundation

struct LoanScheduleListItemViewModel {
    let repaymentValue: String
    let repaymentDate: String
    let description: String
    let loanTotal: String
    let onItemTap: () -> Void
}

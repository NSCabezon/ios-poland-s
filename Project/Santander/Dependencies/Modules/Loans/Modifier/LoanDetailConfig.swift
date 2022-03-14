//
//  LoanDetailConfig.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 7/3/22.
//

import CoreDomain

final class LoanDetailConfig: LoanDetailConfigRepresentable {
    var aliasIsNeeded: Bool = false
    var isEnabledNextInstallmentDate: Bool = true
    var isEnabledCurrentInterestAmount: Bool = true
    var isEnabledFirstHolder: Bool = false
    var isEnabledInitialExpiration: Bool = false
    var isEnabledLastOperationDate: Bool = true
}

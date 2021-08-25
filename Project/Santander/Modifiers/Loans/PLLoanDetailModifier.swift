//
//  PLLoanDetailModifier.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 18/8/21.
//

import Foundation
import Commons
import Models
import SANPLLibrary
import PLLegacyAdapter
import Loans

final class PLLoanDetailModifier {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
        self.dependenciesEngine = dependenciesEngine
    }
}

extension PLLoanDetailModifier: LoanDetailModifierProtocol {
    var isEnabledFirstHolder: Bool {
        return false
    }
    
    var isEnabledInitialExpiration: Bool {
        return false
    }
    
    func formatLoanId(_ loanId: String) -> String {
        return ""
    }
    
    func formatPeriodicity(_ periodicity: String) -> String? {
        return nil
    }
    
    var aliasIsNeeded: Bool {
        return false
    }
    
    var isEnabledNextInstallmentDate: Bool {
        return true
    }
    
    var isEnabledCurrentInterestAmount: Bool {
        return true
    }
}

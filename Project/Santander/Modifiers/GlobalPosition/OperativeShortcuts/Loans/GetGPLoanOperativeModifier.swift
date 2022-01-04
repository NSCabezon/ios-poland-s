//
//  GetGPLoanOperativeModifier.swift
//  Santander
//
//  Created by Francisco Perez Martinez on 5/11/21.
//

import CoreFoundationLib
import Commons
import SANPLLibrary

public final class GetGPLoanOperativeModifier: GetGPLoanOperativeOptionProtocol {
    private var shortcutsOperativesAvailable: [LoanActionType] = [.partialAmortization, .changeAccount]

    public func getAllLoanOperativeActionType() -> [LoanActionType] {
        return self.shortcutsOperativesAvailable
    }

    public func getCountryLoanOperativeActionType(loans: [LoanEntity]) -> [LoanActionType] {
        return self.shortcutsOperativesAvailable
    }

    public func isOtherOperativeEnabled(_ option: LoanActionType) -> Bool {
        return self.shortcutsOperativesAvailable.contains(option)
    }
}

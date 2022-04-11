//
//  GetGPLoanOperativeModifier.swift
//  Santander
//
//  Created by Francisco Perez Martinez on 5/11/21.
//

import CoreFoundationLib
import SANPLLibrary

public final class GetGPLoanOperativeModifier: GetGPLoanOperativeOptionProtocol {
    private var shortcutsOperativesAvailable: [LoanActionType] = [.partialAmortization, .changeAccount]

    public func getAllLoanOperativeActionType() -> [LoanActionType] {
        return [.partialAmortization, .changeAccount, PLCashLoanOperative().getActionType(), PLLoansAliasOperative().getActionType()]
    }

    public func getCountryLoanOperativeActionType(loans: [LoanEntity]) -> [LoanActionType] {
        var shortcutsOperativesAvailable: [LoanActionType] = [.partialAmortization, .changeAccount, PLCashLoanOperative().getActionType()]

        if loans.isNotEmpty {
            shortcutsOperativesAvailable.append(PLLoansAliasOperative().getActionType())
        }
        return shortcutsOperativesAvailable
    }

    public func isOtherOperativeEnabled(_ option: LoanActionType) -> Bool {
        return [.partialAmortization, .changeAccount, PLCashLoanOperative().getActionType(), PLLoansAliasOperative().getActionType()].contains(option)
    }
}

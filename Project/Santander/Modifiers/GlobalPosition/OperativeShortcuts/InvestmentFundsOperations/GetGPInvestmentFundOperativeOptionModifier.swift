//
//  GetGPInvestmentFundOperativeOptionModifier.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 1/12/21.
//

import CoreFoundationLib
import Commons

public final class GetGPInvestmentFundOperativeOptionModifier: GetGPInvestmentFundOperativeOptionProtocol {
    public func getAllFundOperativeActionType() -> [FundActionType] {
        return []
    }
    
    public func getCountryFundOperativeActionType(fund: [FundEntity]) -> [FundActionType] {
        return []
    }
    
    public func isOtherOperativeEnabled(_ option: FundActionType) -> Bool {
        return false
    }
}

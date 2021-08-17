//
//  GetGPInsuranceProtectionOperativeModifier.swift
//  Santander
//

import Models
import Commons

public final class GetGPInsuranceProtectionOperativeModifier: GetGPInsuranceProtectionOperativeOptionProtocol {
    public func getAllInsuranceProtectionOperativeActionType() -> [InsuranceProtectionActionType] {
        return [PLBuyInsuranceOperative().getActionType()]
    }

    public func getCountryInsuranceProtectionOperativeActionType(insuranceProtections: [InsuranceProtectionEntity]) -> [InsuranceProtectionActionType] {
        return [PLBuyInsuranceOperative().getActionType()]
    }
}

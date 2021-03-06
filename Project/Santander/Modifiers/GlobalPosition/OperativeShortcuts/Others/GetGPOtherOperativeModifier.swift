//
//  GetGPOtherOperativeModifier.swift
//  Santander
//

import CoreFoundationLib

public final class GetGPOtherOperativeModifier: GetGPOtherOperativeOptionProtocol {
    public func getAllOtherOperativeActionType() -> [OtherActionType] {
        return [PLOfficeAppointmentOperative().getActionType(),
                PLChangeProductAliasOperative().getActionType()]
    }

    public func getCountryOtherOperativeActionType() -> [OtherActionType] {
        return [PLOfficeAppointmentOperative().getActionType(),
                PLChangeProductAliasOperative().getActionType()]
    }
}

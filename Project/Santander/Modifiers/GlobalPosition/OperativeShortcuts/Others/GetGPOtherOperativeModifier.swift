//
//  GetGPOtherOperativeModifier.swift
//  Santander
//

import CoreFoundationLib
import Commons

public final class GetGPOtherOperativeModifier: GetGPOtherOperativeOptionProtocol {
    public func getAllOtherOperativeActionType() -> [OtherActionType] {
        return [PLOfficeAppointmentOperative().getActionType()]
    }

    public func getCountryOtherOperativeActionType() -> [OtherActionType] {
        return [PLOfficeAppointmentOperative().getActionType()]
    }
}

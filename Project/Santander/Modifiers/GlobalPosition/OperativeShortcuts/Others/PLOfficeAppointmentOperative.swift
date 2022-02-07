//
//  PLOfficeAppointmentOperative.swift
//  Santander
//

import CoreFoundationLib
import UI

final class PLOfficeAppointmentOperative {
    private let identifier: String = "otherOptionButtonAppointmentInOfficePoland"
    private let localizedKey: String = "otherOption_button_appointmentInOffice"
    private let icon: String = "icnCalendar"

    func getActionType() -> OtherActionType {
        return .custom(
            OperativeActionValues(
                identifier: self.identifier,
                localizedKey: self.localizedKey,
                icon: self.icon,
                isDisabled: false))
    }

    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}

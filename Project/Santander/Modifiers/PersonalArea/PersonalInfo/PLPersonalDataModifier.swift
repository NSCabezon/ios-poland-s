//
//  PLPersonalDataModifier.swift
//  Santander
//
//  Created by Alvaro Royo on 28/10/21.
//

import PersonalArea
import Commons

class PLPersonalDataModifier: PersonalDataModifier {
    func buildPersonalData(with personalInfo: PersonalInfoWrapper?) -> PersonalDataInfo? {
        guard let personalInfo = personalInfo else { return nil }
        var personalDataInfo = PersonalDataInfo()
        personalDataInfo.mainAddress = personalInfo.fullAddress
        personalDataInfo.correspondenceAddress = personalInfo.fullAddress
        personalDataInfo.phone = maskedPhone(personalInfo.phone)
        personalDataInfo.smsPhone = maskedPhone(personalInfo.phone)
        let email = (personalInfo.email ?? "").isEmpty ? localized("personalArea_text_uninformed") : personalInfo.email
        personalDataInfo.email = email
        return personalDataInfo
    }
}

private extension PLPersonalDataModifier {
    func maskedPhone(_ phone: String?) -> String? {
        guard let phone = phone, phone.count > 3 else { return nil }
        let asterisks = String(repeating: "*", count: phone.count - 3)
        return asterisks + String(phone.suffix(3))
    }
}

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
        let polandAddress = polandAddress(personalInfo.addressNodes)
        var personalDataInfo = PersonalDataInfo()
        personalDataInfo.mainAddress = polandAddress
        personalDataInfo.correspondenceAddress = polandAddress
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
    
    func polandAddress(_ nodes: [String]?) -> String? {
        guard let nodes = nodes, nodes.count >= 5 else { return nil }
        return concat(strings: [nodes[2], nodes[3], nodes[4], nodes[1]])
    }
    
    func concat(strings: [String?]) -> String {
        var string = ""
        strings.enumerated().forEach({
            guard let str = $1, !str.isEmpty else { return }
            if $0 > 0 { string += " " }
            string += str
        })
        return string
    }
}

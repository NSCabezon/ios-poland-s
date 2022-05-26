//
//  PLPersonalDataModifier.swift
//  Santander
//
//  Created by Alvaro Royo on 28/10/21.
//

import PersonalArea
import CoreFoundationLib

class PLPersonalDataModifier: PersonalDataModifier {

    let dependenciesResolver: DependenciesResolver
    lazy var locale: Locale = {
        let stringLoader: StringLoader = dependenciesResolver.resolve(for: StringLoader.self)
        let identifier = stringLoader.getCurrentLanguage().languageType.rawValue
        return Locale(identifier: identifier)
    }()

    public init(dependencies: DependenciesResolver) {
        self.dependenciesResolver = dependencies
    }

    func buildPersonalData(with personalInfo: PersonalInfoWrapper?) -> PersonalDataInfo? {
        guard let personalInfo = personalInfo else { return nil }
        var personalDataInfo = PersonalDataInfo()
        personalDataInfo.mainAddress = polandAddress(personalInfo.addressNodes)
        personalDataInfo.correspondenceAddress = polandAddress(personalInfo.correspondenceAddressNodes)
        personalDataInfo.phone = maskedPhone(personalInfo.phone) ?? " "
        personalDataInfo.smsPhone = maskedPhone(personalInfo.smsPhone) ?? " "
        personalDataInfo.email = personalInfo.email
        personalDataInfo.emailAlternative = localized("personalArea_text_uninformed")
        personalDataInfo.correspondenceAddressMode = .web
        personalDataInfo.phoneMode = .web
        personalDataInfo.emailMode = .web
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
        return concat(strings: [nodes[2], nodes[3], nodes[4], nodes[1], countryNameFromISO(nodes[safe: 7])])
    }

    func countryNameFromISO(_ countryCodeISO: String?) -> String? {
        guard let countryCodeISO = countryCodeISO else {
            return nil
        }
        return locale.localizedString(forRegionCode: countryCodeISO)
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

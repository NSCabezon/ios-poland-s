//
//  ContactsFilter.swift
//  PhoneTopUp
//
//  Created by 188216 on 12/01/2022.
//

import Foundation
import PLCommons

protocol PolishContactsFiltering: AnyObject {
    func filterAndFormatPolishContacts(_ contacts: [MobileContact]) -> [MobileContact]
}

final class PolishContactsFilter: PolishContactsFiltering {
    // MARK: Properties
    private let phoneNumberDigitCount = 9
    private let phoneNumberFormatter = PartialPhoneNumberFormatter()
    
    // ARK: Methods
    
    func filterAndFormatPolishContacts(_ contacts: [MobileContact]) -> [MobileContact] {
        let contactsStrippedFromSpecialCharacters = contacts
            .map({ MobileContact(fullName: $0.fullName, phoneNumber: $0.phoneNumber.filter("0123456789".contains)) })
        let filteredContacts = contactsStrippedFromSpecialCharacters.filter { contact in
            if contact.phoneNumber.starts(with: "48") && contact.phoneNumber.count == phoneNumberDigitCount + 2 {
                return true
            } else if contact.phoneNumber.starts(with: "0048") && contact.phoneNumber.count == phoneNumberDigitCount + 4 {
                return true
            } else if contact.phoneNumber.count == phoneNumberDigitCount {
                return true
            }

            return false
        }
        
        let formattedContacts = filteredContacts.compactMap { contact -> MobileContact? in
            var phoneNumber = contact.phoneNumber
            if phoneNumber.count == phoneNumberDigitCount + 2 {
                phoneNumber = contact.phoneNumber.replacingOccurrences(of: "^48", with: "", options: .regularExpression)
            }
            phoneNumber = phoneNumber.replacingOccurrences(of: "^0048", with: "", options: .regularExpression)
            guard phoneNumber.count == phoneNumberDigitCount else {
                return nil
            }
            return MobileContact(fullName: contact.fullName, phoneNumber: phoneNumberFormatter.formatPhoneNumberText(phoneNumber))
        }
        
        return formattedContacts
    }
}

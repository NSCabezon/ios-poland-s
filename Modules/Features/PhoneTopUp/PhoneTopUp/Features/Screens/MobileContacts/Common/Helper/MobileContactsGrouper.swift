//
//  MobileContactsGrouper.swift
//  PhoneTopUp
//
//  Created by 188216 on 27/12/2021.
//

import Foundation

protocol MobileContactsGrouping: AnyObject {
    func groupContacts(_ contacts: [MobileContact]) -> GroupedMobileContacts
}

final class MobileContactsGrouper: MobileContactsGrouping {
    func groupContacts(_ contacts: [MobileContact]) -> GroupedMobileContacts {
        let nonLetterGroupingCharacter = Character("#")
        let sortedContacts = contacts.sorted { lhs, rhs in
            return lhs.fullName.compare(rhs.fullName, options: .caseInsensitive) == .orderedAscending
        }
        
        let contactsDictionary: [Character: [MobileContact]] = Dictionary(grouping: sortedContacts) { contact in
            let firstCharacter = contact.fullName.uppercased().first ?? nonLetterGroupingCharacter
            return firstCharacter.isLetter ? firstCharacter : nonLetterGroupingCharacter
        }

        return contactsDictionary.map({$0}).sorted { lhs, rhs in
            if rhs.0 == nonLetterGroupingCharacter {
                return true
            } else if lhs.0 == nonLetterGroupingCharacter {
                return false
            } else {
                return lhs.0 <= rhs.0
            }
        }
    }
}

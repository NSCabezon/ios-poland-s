//
//  MobileContactsEarchFilter.swift
//  PhoneTopUp
//
//  Created by 188216 on 12/01/2022.
//

import Foundation
import PLCommons

protocol MobileContactsSearchFiltering {
    func filterContacts(_ contacts: GroupedMobileContacts, query: String) -> GroupedMobileContacts
}

final class MobileContactsSearchFilter: MobileContactsSearchFiltering {
    // MARK: Properties
    
    private let contactsGrouper: MobileContactsGrouping
    
    // MARK: Lifecycle
    
    init(contactsGrouper: MobileContactsGrouping) {
        self.contactsGrouper = contactsGrouper
    }
    
    // MARK: Methods
    
    func filterContacts(_ contacts: GroupedMobileContacts, query: String) -> GroupedMobileContacts {
        if query.isEmpty {
            return contacts
        }
        let allContacts = contacts.flatMap { $0.contacts }
        let filteredContacts = allContacts.filter { contact in
            return contact.fullName.lowercased().contains(query.lowercased()) || contact.phoneNumber.lowercased().contains(query.lowercased())
        }
        return contactsGrouper.groupContacts(filteredContacts)
    }
}

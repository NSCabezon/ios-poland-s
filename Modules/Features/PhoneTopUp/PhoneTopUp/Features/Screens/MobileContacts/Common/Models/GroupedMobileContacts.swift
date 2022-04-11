//
//  GroupedMobileContacts.swift
//  PhoneTopUp
//
//  Created by 188216 on 03/01/2022.
//

import Foundation
import PLCommons

typealias GroupedMobileContacts = [GroupedMobileContactsSection]

struct GroupedMobileContactsSection: Equatable {
    let groupingCharacter: Character
    let contacts: [MobileContact]
}

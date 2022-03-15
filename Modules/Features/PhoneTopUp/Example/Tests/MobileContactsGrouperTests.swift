//
//  MobileContactsGrouperTests.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 09/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import PLCommons
@testable import PhoneTopUp

class MobileContactsGrouperTests: XCTestCase {
    
    let grouper = MobileContactsGrouper()
    
    let ungroupedContacts = [
        MobileContact(fullName: "123", phoneNumber: "123 456 789"),
        MobileContact(fullName: "", phoneNumber: "123 456 789"),
        MobileContact(fullName: "Anna", phoneNumber: "123 456 789"),
        MobileContact(fullName: "anna", phoneNumber: "123 456 789"),
        MobileContact(fullName: "Bella Zoe", phoneNumber: "123 456 789"),
        MobileContact(fullName: "$uncle", phoneNumber: "123 456 789"),
        MobileContact(fullName: "#wow", phoneNumber: "123 456 789"),
        MobileContact(fullName: "Zoe?", phoneNumber: "123 456 789"),
        MobileContact(fullName: "419", phoneNumber: "123 456 789"),
        MobileContact(fullName: "132", phoneNumber: "123 456 789"),
    ]
    
    let expectedResults = [
        GroupedMobileContactsSection(
            groupingCharacter: "A",
            contacts: [
                MobileContact(fullName: "Anna", phoneNumber: "123 456 789"),
                MobileContact(fullName: "anna", phoneNumber: "123 456 789"),
            ]
        ),
        GroupedMobileContactsSection(
            groupingCharacter: "B",
            contacts: [
                MobileContact(fullName: "Bella Zoe", phoneNumber: "123 456 789"),
            ]
        ),
        GroupedMobileContactsSection(
            groupingCharacter: "Z",
            contacts: [
                MobileContact(fullName: "Zoe?", phoneNumber: "123 456 789"),
            ]
        ),
        GroupedMobileContactsSection(
            groupingCharacter: "#",
            contacts: [
                MobileContact(fullName: "", phoneNumber: "123 456 789"),
                MobileContact(fullName: "#wow", phoneNumber: "123 456 789"),
                MobileContact(fullName: "$uncle", phoneNumber: "123 456 789"),
                MobileContact(fullName: "123", phoneNumber: "123 456 789"),
                MobileContact(fullName: "132", phoneNumber: "123 456 789"),
                MobileContact(fullName: "419", phoneNumber: "123 456 789"),
            ]
        ),
    ]

    func testGroupingContacts() throws {
        let groupedContacts = grouper.groupContacts(ungroupedContacts)
        XCTAssert(groupedContacts == expectedResults)
    }
}

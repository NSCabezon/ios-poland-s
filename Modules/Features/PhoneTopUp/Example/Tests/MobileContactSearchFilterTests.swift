//
//  MobileContactSearchFilterTests.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 10/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import PLCommons
@testable import PhoneTopUp

class MobileContactSearchFilterTests: XCTestCase {
    
    let filter = MobileContactsSearchFilter(contactsGrouper: MobileContactsGrouper())
    
    let groupedContacts = [
        GroupedMobileContactsSection(
            groupingCharacter: "A",
            contacts: [
                MobileContact(fullName: "Anna", phoneNumber: "508 456 780"),
                MobileContact(fullName: "anna", phoneNumber: "606 456 781"),
            ]
        ),
        GroupedMobileContactsSection(
            groupingCharacter: "B",
            contacts: [
                MobileContact(fullName: "Bella Zoe", phoneNumber: "506 456 782"),
                MobileContact(fullName: "Bannana", phoneNumber: "508 456 782"),
            ]
        ),
        GroupedMobileContactsSection(
            groupingCharacter: "Z",
            contacts: [
                MobileContact(fullName: "Zoe?", phoneNumber: "504 456 783"),
            ]
        ),
        GroupedMobileContactsSection(
            groupingCharacter: "#",
            contacts: [
                MobileContact(fullName: "", phoneNumber: "805 456 789"),
                MobileContact(fullName: "#wow", phoneNumber: "608 456 789"),
                MobileContact(fullName: "$uncle", phoneNumber: "508 456 789"),
                MobileContact(fullName: "123", phoneNumber: "404 456 789"),
                MobileContact(fullName: "132", phoneNumber: "510 456 789"),
                MobileContact(fullName: "419", phoneNumber: "500 456 789"),
            ]
        ),
    ]
    
    func testFilteringContactsWithEmptyQuery() throws {
        let query = ""
        let filteredContacts = filter.filterContacts(groupedContacts, query: query)
        XCTAssert(filteredContacts == groupedContacts)
    }
    
    func testFilteringContactsWithQueryThatDoesntMatchAnyContact() throws {
        let query = "some query not matching any contact"
        let filteredContacts = filter.filterContacts(groupedContacts, query: query)
        XCTAssert(filteredContacts.isEmpty)
    }

    func testFilteringContactsByName() throws {
        let query = "ann"
        let expectedResults = [
            GroupedMobileContactsSection(
                groupingCharacter: "A",
                contacts: [
                    MobileContact(fullName: "Anna", phoneNumber: "508 456 780"),
                    MobileContact(fullName: "anna", phoneNumber: "606 456 781"),
                ]
            ),
            GroupedMobileContactsSection(
                groupingCharacter: "B",
                contacts: [
                    MobileContact(fullName: "Bannana", phoneNumber: "508 456 782"),
                ]
            ),
        ]
        
        let filteredContacts = filter.filterContacts(groupedContacts, query: query)
        
        XCTAssert(filteredContacts == expectedResults)
    }
    
    func testFilteringContactsByNumber() throws {
        let query = "508"
        let expectedResults = [
            GroupedMobileContactsSection(
                groupingCharacter: "A",
                contacts: [
                    MobileContact(fullName: "Anna", phoneNumber: "508 456 780"),
                ]
            ),
            GroupedMobileContactsSection(
                groupingCharacter: "B",
                contacts: [
                    MobileContact(fullName: "Bannana", phoneNumber: "508 456 782"),
                ]
            ),
            GroupedMobileContactsSection(
                groupingCharacter: "#",
                contacts: [
                    MobileContact(fullName: "$uncle", phoneNumber: "508 456 789"),
                ]
            ),
        ]
        
        let filteredContacts = filter.filterContacts(groupedContacts, query: query)
        
        XCTAssert(filteredContacts == expectedResults)
    }
}

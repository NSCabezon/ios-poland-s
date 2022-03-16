//
//  PolishContactFilterTests.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 10/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import PLCommons
@testable import PhoneTopUp

class PolishContactFilterTests: XCTestCase {
    
    let filter = PolishContactsFilter()

    let contacts = [
        MobileContact(fullName: "John Doe", phoneNumber: "123 456 789"),
        MobileContact(fullName: "John Doe2", phoneNumber: "0044 506 734 348"),
        MobileContact(fullName: "John Doe3", phoneNumber: "+45-405-7658323"),
        MobileContact(fullName: "John Doe4", phoneNumber: "+48 606 774 663"),
        MobileContact(fullName: "John Doe4a", phoneNumber: "+48 48 48 48    484"),
        MobileContact(fullName: "John Doe5", phoneNumber: "+48-474-349-9989"),
        MobileContact(fullName: "John Doe6", phoneNumber: "+48-474-349-998"),
        MobileContact(fullName: "John Doe7", phoneNumber: "what?"),
        MobileContact(fullName: "John Doe8", phoneNumber: "00 48 758 111 111"),
        MobileContact(fullName: "John Doe9", phoneNumber: "00 45 758 111 111"),
        MobileContact(fullName: "John Doe10", phoneNumber: ""),
        MobileContact(fullName: "John Doe11", phoneNumber: "506734536"),
        MobileContact(fullName: "John Doe12", phoneNumber: "555 666 898"),
        MobileContact(fullName: "John Doe13", phoneNumber: "555-666 -898"),
        
    ]
    
    let expectedResults = [
        MobileContact(fullName: "John Doe", phoneNumber: "123 456 789"),
        MobileContact(fullName: "John Doe4", phoneNumber: "606 774 663"),
        MobileContact(fullName: "John Doe4a", phoneNumber: "484 848 484"),
        MobileContact(fullName: "John Doe6", phoneNumber: "474 349 998"),
        MobileContact(fullName: "John Doe8", phoneNumber: "758 111 111"),
        MobileContact(fullName: "John Doe11", phoneNumber: "506 734 536"),
        MobileContact(fullName: "John Doe12", phoneNumber: "555 666 898"),
        MobileContact(fullName: "John Doe13", phoneNumber: "555 666 898"),
    ]
    
    func testFilteringPolishContacts() throws {
        let filteredContacts = filter.filterAndFormatPolishContacts(contacts)
        
        XCTAssert(filteredContacts == expectedResults)
    }
}

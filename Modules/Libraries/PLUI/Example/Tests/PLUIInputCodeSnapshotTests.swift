//
//  PLUIInputCodeSnapshotTests.swift
//  PLUI_Example
//
//  Created by Marcos Álvarez Mesa on 17/9/21.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import PLUI

class PLUIInputCodeSnapshotTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInputCodeSMSFacade() {
        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodeSMSFacade(),
                                                   elementSize: CGSize(width: 35, height: 40),
                                                   requestedPositions: .all,
                                                   charactersSet: .alphanumerics)
        assertSnapshot(matching: inputCodeComponent,
                       as: .image,
                       record: false,
                       testName: ("PLUIInputCode-SMSFacade"))
    }

    func testInputCodeSMSFacadeWhiteBackground() {
        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodeSMSFacade(facadeStyle: .whiteBackground),
                                                   elementSize: CGSize(width: 25, height: 35),
                                                   requestedPositions: .all,
                                                   charactersSet: .alphanumerics)
        assertSnapshot(matching: inputCodeComponent,
                       as: .image,
                       record: false,
                       testName: ("PLUIInputCode-SMSFacade-WhiteBackground"))
    }

    /* We should fix pin facade before activating this snapshot test
    func testInputCodePinFacade() {
        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodePinFacade(),
                                                   elementSize: CGSize(width: 25, height: 35),
                                                   requestedPositions: .all,
                                                   charactersSet: .alphanumerics)
        assertSnapshot(matching: inputCodeComponent,
                       as: .image,
                       record: true,
                       testName: ("PLUIInputCode-PinFacade"))
    }
     */

    func testInputCodeMaskedPasswordFacade() {
        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodeMaskedPasswordFacade(),
                                                   elementSize: CGSize(width: 25, height: 35),
                                                   requestedPositions: .positions([1, 4, 5, 7, 8, 11, 13, 15, 16, 20]),
                                                   charactersSet: .alphanumerics)
        assertSnapshot(matching: inputCodeComponent,
                       as: .image,
                       record: false,
                       testName: ("PLUIInputCode-MaskedPasswordFacade"))
    }
}


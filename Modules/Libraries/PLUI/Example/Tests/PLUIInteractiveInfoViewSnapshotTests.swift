//
//  PLUIInteractiveInfoViewSanpshotTests.swift
//  PLUI_Tests
//
//  Created by Marcos Álvarez Mesa on 21/9/21.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import PLUI

class PLUIInteractiveInfoViewSanpshotTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInteractiveInfoViewWithImage() {

        guard let image = PLAssets.image(named: "fingerprint") else { return }
        let interactiveInfoView = PLUIInteractiveInfoView(image: image,
                                                          title: "This is the title",
                                                          text: "This is the description")

        assertSnapshot(matching: interactiveInfoView,
                       as: .image,
                       record: false,
                       testName: ("PLUIInteractiveInfoView-WithoutImage"))

    }

    func testInteractiveInfoViewWithoutImage() {

        let interactiveInfoView = PLUIInteractiveInfoView(title: "This is the title",
                                                          text: "This is the description")

        assertSnapshot(matching: interactiveInfoView,
                       as: .image,
                       record: false,
                       testName: ("PLUIInteractiveInfoView-WithoutImage"))

    }
}

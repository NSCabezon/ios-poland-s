//
//  PLUIInteractiveInfoViewSnapshotTest.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 10/12/21.
//

import Foundation
import FBSnapshotTestCase
@testable import PLUI

class PLUIInteractiveInfoViewSnapshotTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        self.recordMode = false
    }

    override func tearDown() {
        super.tearDown()
    }

    func testShortTitleAndDescription() {

        guard let image = PLAssets.image(named: "fingerprint") else { return }
        let view = PLUIInteractiveInfoView(image: image,
                                           title: "This is the title",
                                           text: "This is the description")
        self.verifyView(view: view)
    }

    func testLongTitleLongDescription() {

        guard let image = PLAssets.image(named: "fingerprint") else { return }
        let view = PLUIInteractiveInfoView(image: image,
                                           title: "This is the title This is the title This is the title This is the title This is the title",
                                           text: "This is the description This is the description This is the description This is the description This is the description This is the description This is the is the description This is the description This is the description This is the is the description This is the description This is the description")
        self.verifyView(view: view)
    }

    func testNoImage() {

        let view = PLUIInteractiveInfoView(image: nil,
                                           title: "This is the title",
                                           text: "This is the description")
        self.verifyView(view: view)
    }
}

//
//  PLUIInputCodeViewSnapshotTest.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 16/12/21.
//

import FBSnapshotTestCase
@testable import PLUI

class PLUIInputCodeViewSnapshotTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        self.recordMode = false
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPinFacade() {

        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodePinFacade(),
                                                   elementSize: CGSize(width: 25, height: 35),
                                                   requestedPositions: .all,
                                                   charactersSet: .alphanumerics)
        inputCodeComponent.setText("1234")
        self.verifyView(view: inputCodeComponent)
    }

    func testSMSFacadeWhiteBackgroundBig() {

        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodeSMSFacade(facadeStyle: .whiteBackground),
                                                   elementSize: CGSize(width: 31, height: 56),
                                                   requestedPositions: .all,
                                                   charactersSet: .alphanumerics)
        inputCodeComponent.setText("123456")
        self.verifyView(view: inputCodeComponent,
                        screens: [.iPhoneX])
    }

    func testSMSFacadeWhiteBackgroundSmall() {

        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodeSMSFacade(facadeStyle: .whiteBackground),
                                                   elementSize: CGSize(width: 25, height: 35),
                                                   requestedPositions: .all,
                                                   charactersSet: .alphanumerics)
        inputCodeComponent.setText("123456")
        self.verifyView(view: inputCodeComponent, screens: [.iPhone5])
    }

    func testSMSFacadeBlackBackground() {

        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodeSMSFacade(facadeStyle: .blackBackground),
                                                   elementSize: CGSize(width: 25, height: 35),
                                                   requestedPositions: .all,
                                                   charactersSet: .alphanumerics)
        inputCodeComponent.setText("123456")
        self.verifyView(view: inputCodeComponent)
    }

    func testMaskedPasswordFacadeiPhone5() {

        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodeMaskedPasswordFacade(),
                                                   elementSize: CGSize(width: 22, height: 34),
                                                   requestedPositions: .all,
                                                   charactersSet: .alphanumerics)
        inputCodeComponent.setText("0123456789")
        self.verifyView(view: inputCodeComponent, screens: [.iPhone5])
    }

    func testMaskedPasswordFacadeOtherDevices() {

        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodeMaskedPasswordFacade(),
                                                   elementSize: CGSize(width: 31, height: 56),
                                                   requestedPositions: .all,
                                                   charactersSet: .alphanumerics)
        inputCodeComponent.setText("0123456789")
        self.verifyView(view: inputCodeComponent, screens: [.iPhone6, .iPhoneX, .iPhone13ProMax])
    }

    func testMaskedPasswordFacadeRequestedPositions() {

        let inputCodeComponent = PLUIInputCodeView(delegate: nil,
                                                   facade: PLUIInputCodeMaskedPasswordFacade(),
                                                   elementSize: CGSize(width: 31, height: 56),
                                                   requestedPositions: .positions([1, 4, 5, 7, 8, 11, 13, 15, 16, 20]),
                                                   charactersSet: .alphanumerics)
        inputCodeComponent.setText("01234567")
        self.verifyView(view: inputCodeComponent, screens: [.iPhone6, .iPhoneX, .iPhone13ProMax])
    }
}

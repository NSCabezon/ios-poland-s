//
//  PLLoginManagerTests.swift
//  SANPLLibrary_Tests
//
//  Created by Marcos Álvarez Mesa on 18/5/21.
//

import XCTest
@testable import SANPLLibrary

final class PLLoginManagerTests: Tests {

    private enum Constants {

        static let userId = "33355343"
    }

    private var loginManager: PLLoginManager {

        return PLLoginManager(bsanDataProvider: self.bsanDataProvider,
                              networkProvider: self.networkProvider,
                              demoInterpreter: self.demoInterpreter)
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoginWithNick() {

        let parameters = LoginNickParameters(userId: Constants.userId)
        let result = try? self.loginManager.doLoginWithNick(parameters)

        switch result {
        case .success(let login):
            XCTAssertEqual(String(login.userId ?? 0), Constants.userId)
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting correct user")
        default:
            XCTFail("Not getting correct user")
        }
    }
}

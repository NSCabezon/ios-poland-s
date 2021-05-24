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
        static let userAlias = "oneapp1"
        static let authorizationType = "SMS_CODE"
        static let authorizationValue = "57481439"
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
        let parameters = LoginParameters(userId: Constants.userId)
        let result = try? self.loginManager.doLogin(parameters)

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

    func testLoginWithAlias() {
        let parameters = LoginParameters(userAlias: Constants.userAlias)
        let result = try? self.loginManager.doLogin(parameters)

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

    func testAuthenticateInit() {
        let parameters = AuthenticateInitParameters(userId: Constants.userId, secondFactorData: SecondFactorData(defaultChallenge: DefaultChallenge(authorizationType: Constants.authorizationType, value: Constants.authorizationValue)))
        let result = try? self.loginManager.doAuthenticateInit(parameters)

        switch result {
        case .success(let login):
            XCTAssertEqual(String(login.statusCode), "200")
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting correct user")
        default:
            XCTFail("Not getting correct user")
        }
    }

    func testPubKey() {
        let result = try? self.loginManager.getPubKey()

        switch result {
        case .success(let pubkey):
            XCTAssertTrue(((pubkey.exponent?.isEmpty) != nil))
        case .failure(let error):
            print("Error .\(error.localizedDescription)")
            XCTFail("Not getting correct user")
        default:
            XCTFail("Not getting correct user")
        }
    }
}

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

    func testAuthenticate() {
        let encryptedPassword = "b6a645a744c72ea1c76e4f3345b2a05d9cb56f230822fca9f8d36e4e818a15e1dceb9bf5994dcb97e173f7091c32e953dc70e91db631e9cb390131fd32300ef07e8488e2dd9f0443c5f66c1b8c0a2218080b185e8190ab04642782601e29ad6465afbaeffe05d74ef817b10ddeed1905d814b48037c6562be5baddde84dba8b367a3c9bc595574f1a8ac7d01e7a86bc592c4b03270e5ff4ce844c6a5ed56dd20ed57062a706a16ed5c58775aabcf82c4d822b84cf97edd5a23beef18a69b7ce1316439c04e8f37f553215a8891f4db28131d4cb1cdfbb537a5ab7042845798b560997597d1793e5054602948ff67aa4a3be9d6ae9009e05092b98e9d63f7d0c2"

        let parameters = AuthenticateParameters(encryptedPassword: encryptedPassword, userId: "33355343", secondFactorData: SecondFactorData(response: Response(challenge: Challenge(authorizationType: "SMS_CODE", value: "21794711"), value: "795031")))
        let result = try? self.loginManager.doAuthenticate(parameters)

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

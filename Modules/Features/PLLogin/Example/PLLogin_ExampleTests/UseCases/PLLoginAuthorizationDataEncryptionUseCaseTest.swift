//
//  PLLoginAuthorizationDataEncryptionUseCaseTest.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 20/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Commons
import DomainCommon
import CryptoSwift
@testable import PLLogin

class PLLoginAuthorizationDataEncryptionUseCaseTest: XCTestCase {

    private let dependencies = DependenciesDefault()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // MARK:-
    func testDataAuthoritationEncryption() throws {
        enum Constants {
            enum Input {
                static let randomKey = "Zu1nla86533zCVSmIw=="
                static let challenge = "15712338"
                static let privateKey: SecKey = {
                    let privateKeyBase64 = "MIIEogIBAAKCAQEAs0UFMJEEtkFFAZzOcBQEE7DNtSQI5VECDV6FQNkwkTfvy8va+ERKBUk/EdbUPmOmaWZvpPmyjP50QuDMVTpo86+dwnl4Qym+ZW/hYN2LZEgnn/yfUNlpP5hkU77oDdcB+FsrsbU08dLEYyl9bi0I1DjPJbZgG4Gx5JDYR/5plIUR7xJH+IFI+EFXx014Snrc+MsFsnMUIjwoC3N7C9mCTGMHa5bm7XRy1FSLlyQNDPDy5wOaS/np+Gc5M5ICp9JrfWyMY+KGPGuGZCSlB66HJy4OuhcZW38UYabA6YIj0HGaZQj0HSah4DDvwjuL8QmYGaVK/BY4w+C3II3otCEwAQIDAQABAoIBAFZGPT0mTZI4zzD7eg5OU7f2OsmWUgGqfsZYWuDepZT9ypXVwcgBdW4d1hCLxxFPe+L1vX0z/k4El4coEK5jsea0+cOCGfKYwFyo/1pSxKa6YveH6FRMjW5htMbo9VzTwMr5dYnMn3JR8NmYOhkv6zPXMzn/DzmtrSNG4g+jzMQAh8wBggc6J1CsE2dmwQ4vlbbdir+7LHdZGJfUSZWGkohtqH6pY4Q34pEleFl3ziKcniWULUdLBHDyg3xTpn2nDoo/nXfAFQJ9OZM170ztiyfLYieteOiLV1xMJI5sBBlvw9dhnTeh1z+D5aelJigkWYElQdbENg7/bopT4xBTWdECgYEA5+oktJWYvy4+/4S6O+MIt9EqZEiFwPeqviavOH/XjEOA//U+ZwON2ypQ4xoTw+yCiGH0wIztmpkJ+ew4kiujJ0YFxz+GahqYL3mJH0o+gzXh7Xjafd7RDGxuBbnAmeZn7tKTeBwZKbNX0jtb1yDi3CFZuOSFJXoErcDmft9x9acCgYEAxeM3jQRU05hv+/YhiKknPsiaezCsMe6vzY8UcPWnLwWaLD6Vx3UO1BvXnwRRlFUaOUhLP3gCLr5nHRF2Lpl9UJuscimKudWj+FZeVbLQaIvJLQPxT/P+MTGMfQZCR/64XPolUbjrUtPU0fsEWLoeWDAEo5+3Ju/ydWiYVmn6shcCgYBEv+CJuB9D7Y23ab1bq34WH+eVOvqLrd/r5sPi1+MqLYi8WBNbrm4LHoxEBqL9XcuEaqWHvz9gqSWP9Tr/+fev2M41tts98QxUZo8Du5q0gvCq2TzMO5V1PV+QSvSRqv/8iGg3Hv1Go2fRZs9fAty9rRVP/k6KQZXJfHnX+p1p2QKBgAVVGBwer8J76xiZC1JJbJtOgIstRpaZ3fbmEiDxHa4wsnTawuJ7Dwk8LtVEIoaivHAquIxfSX/E9bZc0Bh1XmEbsMvqvqg/T4nTmfspNGB809D4uDn1UzY0JZsA3ixees1WmEbZes3ik2uNHhLeAQ9TS+y00xSjhp8PUHuTo4PFAoGAb48A/e71NUk3udpNj3LbIw989mZijVFrKzSf3+I6+7BVjWJte079R9AxTbGlzUDulkVC7ERIpqPbyvB65CrPRC3UJM+q1ub+Kf2FADZD9Htcmbbi82bOqgIMrCPwDMGVav4ubE0e4p+TmwxDen2oQJTXLh0JmxAPOttHqaaefto=" // 2048
                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
                }()
            }
            enum Output {
                static let expectedOutput =
                    "lIE/pKEbnhKgWjEenRmxuzzsqPk+Nn5sDn2JBrh+eocSOEO0lMf5EGphn4l9Abpo8/3tgCmURRY3AN6gqS4/6OahB3oEqQ3sqk0JnkU8J8jxnWdx8SO4atc5SmfqNets0J1WkZj6RksmXVcPKNOYuHG7GOZycpJqvgk4fTMlNdJKU5JOAcey4lRmzcUGdIxADIlpedi71Kbg0thlsBaygXQsxtE7RSKGzDwtpeq1skq+8Lr78vSkpsj1TNlShoPKSkmN+e0rKwhGi/b6LSMC5lpspd2+LP9I7AyuFkXtw82ynXzoYyRrwHTHorGr4NPu0riUNN2zGksP2kUqXi8iITzBPaiMw60N8s4Hzn6PGT6e8O03m4XoUUwcOcZ38id9"
            }
        }

        do {

            let useCase = PLLoginAuthorizationDataEncryptionUseCase(dependenciesResolver: self.dependencies)
            let input = PLLoginAuthorizationDataEncryptionUseCaseInput(randomKey: Constants.Input.randomKey,
                                                                      challenge: Constants.Input.challenge,
                                                                      privateKey: Constants.Input.privateKey)
            let response = try useCase.executeUseCase(requestValues: input)
            let result = try response.getOkResult()

            XCTAssertEqual(result.encryptedAuthorizationData, Constants.Output.expectedOutput)
        } catch {
            XCTFail("testReencryption Error")
        }
    }
}

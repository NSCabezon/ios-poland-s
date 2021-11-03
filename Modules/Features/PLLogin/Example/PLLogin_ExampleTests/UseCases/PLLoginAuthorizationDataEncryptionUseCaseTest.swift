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
                static let randomKey = "150uzNDx9RHZFa2dl5XpNAc/glHqmtkasbsRb6FyzA4="
                static let challenge = "08407364"
                static let pin = "1357"
                static let trustedDeviceAppId = "OneAppc23ec0d1c80611ef99"
                static let storedEncryptedUserKey = "MkJm5Z0YBq/NS6X1QrxV7wyfsgD8ku0nndC7Fv3N4/c="
                static let privateKey: SecKey = {
                    let privateKeyBase64 = "MIIEogIBAAKCAQEAl9ZOJ7jZlTlEncfZizsZzVccndpNZK8Zwo2wYA3/6ikSIP4OYVRlbgd3YLl1rCxA/B8ivJEQ+Z4t376eujeuHd8OW8lhu0rvTETbe9I/KTD6W1yrPEhxdbU/xxC9eCZeNMQ8xkuvonxvxLC9ZyqIkoGmloWV497lhp9/gG/6rMih5TeigPoSdF/Pgi894PrJs4c/UhX3/RenynMBuzqUeX/dVuoNXvqv2rGFioKG87EYyYkai1lZcuQIsEwO/KPq2UmC7BwRVM20oTHuHwzS4ql1KYvpqcFzvq7BtI0ELR7Sy48kmA0wRJFgjKPblDTuiL68vpNDcx0ghlgFviOcVQIDAQABAoIBAAKtexXcvuuQhbsBl/7KVUdngp/vBl/g7aOec46SGKIExObTjCXfwuUomQyZ4K8fXasEkoyAQ2wfg8AXIL34dufcc+ie+cv/g45VBYjeuZHspPGhBf0LawLQJjaIv0qj5JPqJQc7NPb42lC97C0qVRu+URWE+BJ7bxFLdUhq0SEkZq1NrBRd2YEt3pdiGhUxe9v7mXosUK2c+l9eu7BdQPNFHoin90Prx+da6HPZFWj1HmwqPCMaXEbMSm8PROxdTtimXpFEB7wELpotUo8V2v0/D0B4Oc1XgwjODKt9UetYkN4Sin+n1b9CRf+MaBit4pf+RaATVEdr2HbVfUuhSdECgYEA0PrNeZAgbUEhXJhtf4WXq7dgpCb3l9ETxNHCDiv8fp2F8ZV+OrBu2hboMda8HwNLcUZMDHTK+ujFB9l32tUh+1fcvTCbUoZXETHYg0F0+xuLKHZfOEfNQCFRtoSp8llHegAxxOIdBudhEgJwR5nSkpCl40UpchL8uXx7rbSForECgYEAugAZjzXdDT51J7Z96peCjwNqAbftu9V7/7CDh9U/5gKAhr7RkJa5gMn5i8vMxbxWghJLG9tqdRj5dn1MJoCcTYrKeYGPCDlNBnoqBPCpRQK/Kk4szIBlaog/M7aP3FqEZxsgHPCeD8KFXJbZHjstalaY2dceUXVc8/v4xzRnVOUCgYAkqszgtnwqD1J2N7yGsn8BPySyyK+KsMGiOBeveuJLqQH2eH90dr6Mf5ZwIDhTzLUxA9+WE+wFiFAB55NTDzBuNGVjwKKQIUgnmTJfHV4ULSoGiHZ+noKR7Qa0WqSjBC05Z81TuUTUkEaE7W6b8Y5z7vNcZCc4f8JeHUxqFxGXkQKBgDTbUmggJnFdDm36rk28QJ3jmnxiiGyYfmRrBPXU5BO5Ik0obOVp781pmEDh6Y9Htk3AZRfFgrtEHaBOexV19vUSO/fLmZn8rqbokIhW28OAxFKBZLm4wxlDHrLTbo5wKrAiRT30IvbXkI5/T7QHnSBa+5TsTPFZKNEtCcWSXssBAoGAH4ZQb2wuPztJR5/pwk0V8UGENzsMQ5TF1xU0PZ36jTKcfdaduluUTxxMbVrtcbOcPvvp+SWxxZ/qZJAAWhukFy+8SY9wDrUp9KX9eXFTt+keC6L+oYRyO7wFETjFkBhU4YHB91WSNKij+JIFb9cYDGYG8ozh4GB5dWHm0oUpqGA="
                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
                }()
            }
            enum Output {
                static let expectedOutput =
                    "r3D/GvyZWU01ZNoYiz5/fNMCZ0ORYXpvrTRwIXM4g9VAt/6QZ0L1/Lfpe0m6ejk35AqqQ5P6okeb9qwrAboURMeWCwjKwaF0Hq2vfSzD9o962gNXYW5MKJU+G79GWP7ovK5h/4hy1yHGOBRYRNZM6QgDJBU3jodKiVvySUo5jQ6imxRvL57UMM22lSLP7TIRKAxe5DfGZ1Muy59C6RgX8G7Uk4kY/FAIDPsi24p8N3Kj3+2DICp66xacy0WFxHBFC1yvZflt6Gn4C/IJJIUqr1JYTN1qBIRN9uSIwiZL5k1PHLuYtcQNn+YFJuuj9SBNOEa5V3GritjrncnNZhFD+2E5DQVkxZ10gGY+/teIzl8Q1pXnzSqR6f8NsHnYJYHX"
            }
        }

        do {

            let useCase = PLLoginAuthorizationDataEncryptionUseCase(dependenciesResolver: self.dependencies)
            let input = PLLoginAuthorizationDataEncryptionUseCaseInput(appId:  Constants.Input.trustedDeviceAppId,
                                                                       pin: Constants.Input.pin,
                                                                       encryptedUserKey: Constants.Input.storedEncryptedUserKey,
                                                                       randomKey: Constants.Input.randomKey,
                                                                       challenge: Constants.Input.challenge,
                                                                       privateKey: Constants.Input.privateKey)
            let response = try useCase.executeUseCase(requestValues: input)
            let result = try response.getOkResult()

            XCTAssertEqual(result.encryptedAuthorizationData, Constants.Output.expectedOutput)
        } catch {
            XCTFail("testReencryption Error")
        }
    }


    func testDataAuthoritationEncryptionForPoland() throws {
        enum Constants {
            enum Input {
                static let randomKey = "c8jkcy9xJBM3CMO/Ssiia5YDoLrlnS1a7CQ0enpjSY0="
                static let challenge = "76049936"
                static let pin = "1357"
                static let appId = "OneApp74a48dacd3a7484424"
                static let storedEncryptedUserKey = "TUCES38EOm6lI7EQunUETkltokeZvHNoEjE2lOmXLbw="
                static let privateKey: SecKey = {
                    let privateKeyBase64 =  "MIIEogIBAAKCAQEAl9ZOJ7jZlTlEncfZizsZzVccndpNZK8Zwo2wYA3/6ikSIP4OYVRlbgd3YLl1rCxA/B8ivJEQ+Z4t376eujeuHd8OW8lhu0rvTETbe9I/KTD6W1yrPEhxdbU/xxC9eCZeNMQ8xkuvonxvxLC9ZyqIkoGmloWV497lhp9/gG/6rMih5TeigPoSdF/Pgi894PrJs4c/UhX3/RenynMBuzqUeX/dVuoNXvqv2rGFioKG87EYyYkai1lZcuQIsEwO/KPq2UmC7BwRVM20oTHuHwzS4ql1KYvpqcFzvq7BtI0ELR7Sy48kmA0wRJFgjKPblDTuiL68vpNDcx0ghlgFviOcVQIDAQABAoIBAAKtexXcvuuQhbsBl/7KVUdngp/vBl/g7aOec46SGKIExObTjCXfwuUomQyZ4K8fXasEkoyAQ2wfg8AXIL34dufcc+ie+cv/g45VBYjeuZHspPGhBf0LawLQJjaIv0qj5JPqJQc7NPb42lC97C0qVRu+URWE+BJ7bxFLdUhq0SEkZq1NrBRd2YEt3pdiGhUxe9v7mXosUK2c+l9eu7BdQPNFHoin90Prx+da6HPZFWj1HmwqPCMaXEbMSm8PROxdTtimXpFEB7wELpotUo8V2v0/D0B4Oc1XgwjODKt9UetYkN4Sin+n1b9CRf+MaBit4pf+RaATVEdr2HbVfUuhSdECgYEA0PrNeZAgbUEhXJhtf4WXq7dgpCb3l9ETxNHCDiv8fp2F8ZV+OrBu2hboMda8HwNLcUZMDHTK+ujFB9l32tUh+1fcvTCbUoZXETHYg0F0+xuLKHZfOEfNQCFRtoSp8llHegAxxOIdBudhEgJwR5nSkpCl40UpchL8uXx7rbSForECgYEAugAZjzXdDT51J7Z96peCjwNqAbftu9V7/7CDh9U/5gKAhr7RkJa5gMn5i8vMxbxWghJLG9tqdRj5dn1MJoCcTYrKeYGPCDlNBnoqBPCpRQK/Kk4szIBlaog/M7aP3FqEZxsgHPCeD8KFXJbZHjstalaY2dceUXVc8/v4xzRnVOUCgYAkqszgtnwqD1J2N7yGsn8BPySyyK+KsMGiOBeveuJLqQH2eH90dr6Mf5ZwIDhTzLUxA9+WE+wFiFAB55NTDzBuNGVjwKKQIUgnmTJfHV4ULSoGiHZ+noKR7Qa0WqSjBC05Z81TuUTUkEaE7W6b8Y5z7vNcZCc4f8JeHUxqFxGXkQKBgDTbUmggJnFdDm36rk28QJ3jmnxiiGyYfmRrBPXU5BO5Ik0obOVp781pmEDh6Y9Htk3AZRfFgrtEHaBOexV19vUSO/fLmZn8rqbokIhW28OAxFKBZLm4wxlDHrLTbo5wKrAiRT30IvbXkI5/T7QHnSBa+5TsTPFZKNEtCcWSXssBAoGAH4ZQb2wuPztJR5/pwk0V8UGENzsMQ5TF1xU0PZ36jTKcfdaduluUTxxMbVrtcbOcPvvp+SWxxZ/qZJAAWhukFy+8SY9wDrUp9KX9eXFTt+keC6L+oYRyO7wFETjFkBhU4YHB91WSNKij+JIFb9cYDGYG8ozh4GB5dWHm0oUpqGA="
                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
                }()
            }
            enum Output {
                static let expectedOutput =
                    "40LypQV1Y4nyEHgbizFYpl2wFPrWRCVdq7obg/V96apGqJTD+Ryd4RZ3IXmaqopmPQd4aFrwMaQgA0wmIZiukjqTsG8riWfyJ0YuqNWcgT8faKXH/mbn+oG2Z1ImrpRr67wK8Pzyb5gWLknpqgC8UQl1J1oDRXy6L+KvmGNhm9QaL6YKA740NhEsH7w1fRbRHKi94e/UoHhcVsYP67MiaHdne71wJd8mcc+ocRk5Uk3fgh/1BfgPFekA4/rLHuV5Y3Wj1FxSrhaSoc9ZJu6NCcXWhvZOzRVDu8IMZnLllw1W/FdNSwHD8Uo+9rtOw945zImOIYGLOAzr8+DzrqaaOxFLemte8PbLkeuVhnZDRGI6DNDLMi5Bu9Zgv1hB3UoK"
            }
        }

        do {

            let useCase = PLLoginAuthorizationDataEncryptionUseCase(dependenciesResolver: self.dependencies)
            let input = PLLoginAuthorizationDataEncryptionUseCaseInput(appId:  Constants.Input.appId,
                                                                       pin: Constants.Input.pin,
                                                                       encryptedUserKey: Constants.Input.storedEncryptedUserKey,
                                                                       randomKey: Constants.Input.randomKey,
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

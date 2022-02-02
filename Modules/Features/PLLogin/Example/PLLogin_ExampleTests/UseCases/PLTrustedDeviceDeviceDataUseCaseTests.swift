//
//  PLTrustedDeviceDeviceDataUseCaseTests.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 24/6/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import CoreFoundationLib
import PLCommons
import CryptoSwift
@testable import PLLogin

class PLTrustedDeviceDeviceDataUseCaseTests: XCTestCase {

    // All tests are based in TMA_creation_v7.docx shared here https://saneu.atlassian.net/wiki/spaces/MOVPL/pages/2333540357/TMA+-+Trust+device+process
    // We have included some changes that was correct in this document

    private let dependencies = DependenciesDefault()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testTransportKeyEncryptionWithPassKey() throws {

        enum TransportKeyEncryption {
            enum Input {
                static let password = "348x!z" // String as user instroduces (normal or masked)
                // let TKey = Array<UInt8> = [0xAE, 0x12, 0x5F, 0xBC, 0x8D, 0x22, 0x7E, 0x04, 0x6E, 0x56, 0xBB, 0x12, 0xC4, 0x5F, 0x21, 0xB2]
                // let hexString = Data(TKey).toHexString() == "ae125fbc8d227e046e56bb12c45f21b2"
                // let hexabytes = hexString.hexaBytes // TKey = hexabytes
                static let transportKey = "ae125fbc8d227e046e56bb12c45f21b2" // Hex string 32 characters (16 bytes)
            }
            enum Output {
                // Base64 ecnrypted transportKey
                static let encryptedTransportKey = "NRYjSGEXRRzhyLNgyD4aBw=="
            }
        }

        do {
            let useCaseResponse = try transportKeyEncryptionUseCase(PLDeviceDataTransportKeyEncryptionUseCaseInput(transportKey: TransportKeyEncryption.Input.transportKey,
                                                                                                                   passKey: TransportKeyEncryption.Input.password))
            let output = outputFromTransportKeyEncryption(useCaseResponse)
            XCTAssertEqual(output?.encryptedTransportKey, TransportKeyEncryption.Output.encryptedTransportKey)
        } catch {
            XCTFail("PLPasswordEncryptionUseCase: throw")
        }
    }

    func testParametersEncryptionWithTransportKey() throws {

        enum ParametersEncryption {
            enum Input {
                static let transportKey = "ae125fbc8d227e046e56bb12c45f21b2"
                static let parameters = "<2021-04-18 22:01:11.238><<AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>>"
            }
            enum Output {
                static let encryptedParameters = "x3EJNHtL0QkMbQZ/LJ/6Vw8WwdgFo4Av27P0wKNSI/6bADoCzQ+xnnI73VMWO3BkZHBJD0dMJzX93qnFjixJkpKVq4fWaRToU+AKEIq1wb+dh6ylGhxdN/HRhW6dOiJNNWORBdwT7bsmy2/9/NuJEYsA4uCoo1xa2xrxa2o93T/guLj5RdglcdY0sc8gW0uJ"
            }
        }

        do {
            let useCaseResponse = try parametersEncryptionUseCase(PLDeviceDataParametersEncryptionUseCaseInput(parameters: ParametersEncryption.Input.parameters,
                                                                                                               transportKey: ParametersEncryption.Input.transportKey))
            let output = outputFromParameterEncryption(useCaseResponse)
            XCTAssertEqual(output?.encryptedParameters, ParametersEncryption.Output.encryptedParameters)
        } catch {
            XCTFail("PLPasswordEncryptionUseCase: throw")
        }
    }
}

// PRAGMA MARK: TransportKey ecnryption test
private extension PLTrustedDeviceDeviceDataUseCaseTests {

    // MARK: Handle useCase response
    func transportKeyEncryptionUseCase(_ input: PLDeviceDataTransportKeyEncryptionUseCaseInput) throws -> UseCaseResponse<PLDeviceDataTransportKeyEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let useCase = PLDeviceDataTransportKeyEncryptionUseCase(dependenciesResolver: self.dependencies)
            let response = try useCase.executeUseCase(requestValues: input)
            return response
    }

   func outputFromTransportKeyEncryption(_ response: UseCaseResponse<PLDeviceDataTransportKeyEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>) -> PLDeviceDataTransportKeyEncryptionUseCaseOutput? {
            let output = try? response.getOkResult()
            return output
    }
}

// PRAGMA MARK: parameters ecnryption test
private extension PLTrustedDeviceDeviceDataUseCaseTests {

    // MARK: Handle useCase response
    func parametersEncryptionUseCase(_ input: PLDeviceDataParametersEncryptionUseCaseInput) throws -> UseCaseResponse<PLDeviceDataParametersEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
        let useCase = PLDeviceDataParametersEncryptionUseCase(dependenciesResolver: self.dependencies)
            let response = try useCase.executeUseCase(requestValues: input)
            return response
    }

   func outputFromParameterEncryption(_ response: UseCaseResponse<PLDeviceDataParametersEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>) -> PLDeviceDataParametersEncryptionUseCaseOutput? {
            let output = try? response.getOkResult()
            return output
    }
}

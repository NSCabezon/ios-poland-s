//
//  PLTrustedDeviceSofTokenUseCaseTests.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 2/7/21.
//

import XCTest
import Commons
import DomainCommon
import CryptoSwift
@testable import PLLogin

class PLTrustedDeviceSofTokenUseCaseTests: XCTestCase {

    private let dependencies = DependenciesDefault()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    private let privateKey: SecKey = {
        // Tengo que coger una de las private keys que estoy generando junto con la public key para poder desencriptar la infromación
        let privateKeyBase64 = "MIICWwIBAAKBgQDFYfKNi79mffVrO6QKoZEc/6Abu6RWWGsXkbsafei7A4iq3G+YTvMGtYGAwDvIuEY2CdjzcxQQFmRSxO3lmvHfxDPT2BCd5b2Fx2DNS9+deGExxVRcL/+XsA/9WmXvWd06hJTwZa/Jg4sVm45hpccVxl8GJzNSdbGPx5CUVgskoQIDAQABAoGALyRMHoNchNmblm9pqAJbmr3w2v7ParH2bewn8FVXEuduqkQ4wPtGLvmFwx7miHN+jWR/tPFsvsTiVCRlnzuI/dnD7xZyVlPx5tAJ7y2/b4zdw04zJwV0RtaXGrrLMQhqmIup/PGSkweN+1RPBa/sV+3hrEU/lPCAj9tXO7voypsCQQDlbAOqDX/c9WncqzSPMHHDmHphT/HvAxQzW5ZF47CFtWaJbWJV2/gJDrutECTxfsDhxvVmZtN0ofJfdhraeDy7AkEA3D+9fvBi2CEcI3uB7T2zmMMvfNZD5BV5nnJKJj9ObgopClCz8IPbIDzL/PYz48DIMYsqt+M8JpzPzo0O1hEcUwJAKtSWfonUpCCg6dSAlHbb1kNCHaa6KP/vJoNjs5qFWwD5qpBkOlk9nhtFCFMqQneCdOQa7komEfEl+ZJoAv9NfwJAfsWJcvk2S6SzJ5E9dapgJ3uhZ7+EkFH0EMlD+MPThu7+NFvDVpruk52q5E1qDJu4Hxw1WGbJBoiX7BGxCnIK1QJAUSXiHzXo8Ipj7N2ENybgi3XLvT0g9Op6W7F/6h5ymJcFslQax3SbQECSaGsUIJ8Z1mE+KcKMI4XqxNlQPR+GQg=="
        return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
    }()

    // PRAGMA MARK: Test Use case for parameters encryption with private key
    func testSoftwareTokenParametersEncryptionWithPrivateKey() throws {

        enum ParametersEncryption {
            enum Input {
                static let parameters = "<2021-04-18 22:01:11.238><<AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>>"
            }
        }

        do {
            let input = PLSoftwareTokenParametersEncryptionUseCaseInput(parameters: ParametersEncryption.Input.parameters,
                                                                        key: self.privateKey)
            let useCase = PLSoftwareTokenParametersEncryptionUseCase(dependenciesResolver: self.dependencies)
            let response = try useCase.executeUseCase(requestValues: input)
            let output = try? response.getOkResult()
            XCTAssertNotEqual(output?.encryptedParameters, nil)
            // TODO: We can test that it can be decrypted with the private key but we need also to make the reverse process for the parameters separation sha256 and so on. Or maybe only verify that it was signed with the certificate that was created (which is what tey are doing in the baskend)
        } catch {
            XCTFail("PLPasswordEncryptionUseCase: throw")
        }
    }

    // PRAGMA MARK: Test separate and encrypt parameters string
    func testDeviceParametersSeparation() {
        enum Input {
            static let parameters = "<2021-04-18 22:01:11.238><<AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>>"
        }
        enum Output {
            static let result = "PDIwMjEtMDQtMTggMjI6MDE6MTEuMjM4Pjw8QXBwSWQ+PDEyMzQ1Njc4OTBhYmNkZWYxMjM0NTY3OD5MSGwer2CoMmP72bsKJR4jiiLL0iN3tXvHVmT/o8l75Q=="
        }

        let encryptedParameters = PLSoftwareTokenParametersEncryptionUseCase.separateAndEncryptParameters(parameters: Input.parameters)
        XCTAssertEqual(encryptedParameters?.toBase64(), Output.result)
    }
}

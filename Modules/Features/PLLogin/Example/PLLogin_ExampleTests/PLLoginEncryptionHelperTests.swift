//
//  PLLoginEncryptionHelperTests.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 18/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import CoreFoundationLib
import PLCommons
import CryptoSwift
@testable import PLLogin

class PLLoginEncryptionHelperTests: XCTestCase {

    private let dependencies = DependenciesDefault()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // MARK:-
    func testDesalted() throws {
        enum Constants {
            enum Input {
                static let decryptedAndSaltedUserKeyAsHexString = "00463DB90E4B6BDD57A7F0888C228C8F937F708AB8D8D77035B2238BAE4433C32DD1AD1BD52EFF005880FC156A30367C794048DFF60608D25575340983AA340AAF031BA4AB215B8D88B4F63DF8320BD952C362E6F1EB2AF71B256D54D68FADBF6CFA10396F0C361C248DF39AB890730718A77BBE9F5833A817FAE95E80A5DD425C0A337543C4FD9910C2208D9EC7BA557BF1C390549D296772F0A7624BE5978CC21396374743EC0C5759049B7558FC7E16D0FF4392A49382EA6CF61722FD59A819DE284C68C2BC3C5358C3015646C6B8E825333C49A027D2B78B212292A293AEA6877AAA9BDA29EB94CF498D25C72644F08D83A366F7433B2F51F313C97A857E"
                static let privateKeyLength = 2048
                static let softwareTokenKeyLength = 256
            }
            enum Output {
                static let desaltedResult: Array<UInt8> = [67, 70, 50, 69, 54, 67, 57, 66, 69, 56, 68, 55, 55, 68, 48, 69, 50, 51, 49, 50, 65, 55, 65, 48, 51, 69, 65, 69, 54, 52, 70, 65, 68, 53, 68, 50, 65, 68, 52, 49, 67, 57, 48, 51, 49, 56, 70, 49, 54, 67, 53, 69, 49, 48, 67, 67, 52, 57, 48, 52, 65, 70, 67, 48]
            }
        }

        do {

            let result = try PLEncryptionHelper.desaltFromPublicKeyEncryption(hexString: Constants.Input.decryptedAndSaltedUserKeyAsHexString,
                                                                                   privateKeyLength: Constants.Input.privateKeyLength,
                                                                                   symmetricKeyLength: Constants.Input.softwareTokenKeyLength)
            XCTAssertEqual(result, Constants.Output.desaltedResult)
        } catch {
            XCTFail("testDesalted Error")
        }
    }

    //MARK:-
    func testSymetricKey() {
        enum Constants {
            enum Input {
                static let appId = "OneApp651d4c6360bd538cf4"
                static let pin = "1357"
            }
            enum Output {
                static let symetricKey: Array<UInt8> =  [45, 66, 49, -61, 49, -21, -23, -119, 111, -51, -33, 4, 94, 120, 98, -43, 99, 112, -23, -121, 60, -52, -115, -122, 77, -27, -35, 60, 97, -76, -118, 104].map { UInt8(bitPattern: $0) }
            }
        }

        do {
            let result = try PLEncryptionHelper.createSymmetricKeyForSoftwareTokenUserKeyUsage(appId: Constants.Input.appId,
                                                                                                    pin: Constants.Input.pin)
            XCTAssertEqual(result, Constants.Output.symetricKey)
        } catch {
            XCTFail("testSymetricKey Error")
        }
    }

    //MARK:-
    func testCalculateHash() {
        enum Constants {
            enum Input {
                static let randomKey: [UInt8] = [-103, 54, 64, -73, 33, 55, -13, 3, 22, 85, 56, 90, -60, -15, 63, 83, 58, 96, 14, 3, 76, -125, -38, -2, 66, 119, 73, 58, -68, 82, 49, 72].map { UInt8(bitPattern: $0) }
            }
            enum Output {
                static let expectedOutput: Array<UInt8> =  [-89, 114, -127, 65, -90, -54, 111, 118, -90, 33, -94, -44, -104, 64, 101, -93, 56, 15, 82, -123, 126, 48, -34, -85, 79, 58, 92, 46, -1, 16, -87, 83].map { UInt8(bitPattern: $0) }
            }
        }

        let result = PLEncryptionHelper.calculateHash(randomKey: Constants.Input.randomKey)
        XCTAssertEqual(result, Constants.Output.expectedOutput)
    }

    // MARK: -
    func testCreateInitialiationVector() {
        enum Constants {
            enum Input {
                static let appId = "OneApp651d4c6360bd538cf4"
            }
            enum Output {
                static let expectedIV = "FEEA00651D4C6360BD538CF400000000"
            }
        }

        do {
            let vector = try PLEncryptionHelper.createInitializationVectorByTrustedDeviceAppId(appId: Constants.Input.appId)
            XCTAssertEqual(vector.toHexString().uppercased(), Constants.Output.expectedIV)
        } catch {
            XCTFail("testCreateInitialiationVector Error")
        }
    }

    // MARK: -
    func testCalculateAuthorizationData() {
        enum Constants {
            enum Input {
                static let randomKey = "4lvuJY6oaPGo5n58BIYZB8LeK5etU+wKvZcXORestGs="
                static let challenge = "87658651"
                static let privateKey: SecKey = {
                    let privateKeyBase64 =
                    "MIIEowIBAAKCAQEA0VYHiw9o7YB5guzcqzlHkNiJxCoNlOkPW8qs/ghO7dKPuB36cY1BPlzkf5apEkIAgCuHT1JdINn+a8KSRpKwFgIyfwmf2WwOW/acOQAOjzdSmZLNgWSyh043cB5kMm78P7RpuV3NYfs74V+DJ3lyr7L2qnpsU8lDV0Yy4XXOz1Diks7oPYXag3NI9p27Iuic9IBs1j0ia1I4hONtZVszX3/dW3mwloiDQUXUfGwEkfJ7tz6oeXkHyIKiZZPImZn4LamtI17KBa/i3/cMTMClh1jGC/1KEmmrhl9AiCV+PL5L6R0QhIbKqLFJGQYVn04xJWn+Yuik+Nn9DPy3aZ7vkQIDAQABAoIBAAj8NVSts6ZGFnEdM5eR3NWFxdwKpgyXOFaLS4OX3bNtj0eq2b4X/w3rNM+ZKuaiuJzHwYYRFfg8AySi9F5dG3vGWl6Djj3p2m/uFOSJcRaKnFwFJhcAuH0ASXbhhxF3HBKr7sHLGe6ztu1EiT+fgeGyv82vdYjfIanUVIjC4r6ZOVCZPzsopbGzgJGI29/+6n8G2ySU9BA0z8YqVFAHpj9FNjN4gyh+fppD2DygdAVS78PvEpOrvbMJFbtiGXj6h8H6Q7Oo8W6/FcrvlEVWOlEjnoNiPTi0bArvPdY0dh/Aj3rS/vt3623YzRmvrSC3XEgJYVGpSCoSis1tHArLJTECgYEA6kWoIzl9oqmOyszJf0E6MoEDnSxfIhGu7qJFGKGCAQC4e/LIKgNnOl+ti7WiVP8JnBtYqGdO/061RmUDM96rk+ngmXDsHPew5iDIzLkFVecBNY5o9Ld4XrSgHiw+9DyNWzCxEKC9Njq0Fe9p5QrP9i8+Yhnpwdq+9dEsIaunc00CgYEA5MBQX/ZNH4VUfyk+fd/KCXGip31yjjbLPfctKsdPY24GrYTXJRtOgYJFVQT5Ic6Fwn+ziVTXut4zlJC70mzZB3vAjTJvTOO43RMlOE3ieaNCkts/R1htRfYfh8pDhG4Qbhd62eXjtTaLoQ2xDA0IGsziaMWehxQH1l3Entn6w1UCgYAhmSHXA2zAQl8HOL2BMaKeEaCqDu4J3c1fzgfo02joqejLZfNNCzXnykcCbWc9l2IScF2TsVVECk63LM97xeiHixg6CVbjhKZrKrKBodthCYND4gutZQ6vTmpUSXYx4ulG9cG/J75bI6omJzLhtV5D6VyiByNeOPgAGyKgJZUbVQKBgQDRt874a6NBZseU3YdBd86O4fOxgr1nzKyA3wA13AzYp6LPqp5kkqhi68AMtkaBzAmty84Z9gLie5zmc9r+jHRc/AQIb1jDMXPmmwrgl+cuhZMfeIqHKnbkUUWPBMzpuM6vYC9tXepp1Nwmh5rt5XSsvXJFhAhW5vJYghclW8sfEQKBgC9NCTyOb5twCTQFbzEVh3Bw9I5KZGQAOByp6XzHrxQk78KUQ9O0l1bu1lxI+x7yITYvgExAG/gfc8f0oZr1Pj1RO6DZhCufTgR6XUbZ4zGWnSFo8jZvcgAe93ZwqipjlyZycSth6NqTofOobOsEZAYqEZ4KCNEv5N9dojHNBP6W"
                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
                }()
            }
            enum Output {
                static let expectedOutput =
                    "9eUmZnlC8vekUJcWnDK6ATK2iXCK8k+jlTOjxMwJtccgoLHbejtSA5K73Rja69DlVeV4ioVYlnq2eix2tWzp6pRVFc+rMVgx4VaFVAs3bQoH8BcoCek3vvNrqZAyH15VGB+jm4VTgEhJf9KywFEwSSrbIFLvcqsUHE39rt19jn0sgX69UIMWM2RpwuHuaJKBoZTc1RU9F8Ukd008sODGZUK3Mi4SquDFsa8co4WgTyg0P3qYv12PojYWsekh+TPI9ZW8gi4dz3A1v+tH5fWvQNS+7PtAjaXo4HAfI2w9SY/2jV4J225guVYsgvX+YW66eUdF+ORWtKyWg+9rQ4gWo+a8D9yrz/WB9STvXXjXwC1lTq9F71IG7HXtkBqKvgFg"
            }
        }

        do {
            let result = try PLEncryptionHelper.calculateAuthorizationData(randomKey: Constants.Input.randomKey,
                                                                                challenge: Constants.Input.challenge,
                                                                                privateKey: Constants.Input.privateKey)
            XCTAssertEqual(result, Constants.Output.expectedOutput)
        } catch {
            XCTFail("testCalculateAuthorizationData Error")
        }
    }

    // MARK: -
    func testGetRandomKeyFromSoftwareToken() {
        enum Constants {
            enum Input {
                static let appId = "OneApp404e977d770d9f19ba"
                static let pin = "1357"
                static let randomKey = "yZEwic5MEfBr+jtoeLDWOVwHmLngs47QNNyDAHrEVD0="
                static let encodedAndEncryptedUserKey = "CoKuEJbDEN0B8Txh32I25Zgb4QIVz21BRkZ5X3z3xiM="
            }
            enum Output {
                static let expectedOriginalRandomKey = "4lvuJY6oaPGo5n58BIYZB8LeK5etU+wKvZcXORestGs="
            }
        }

        do {
            let result = try PLEncryptionHelper.getRandomKeyFromSoftwareToken(appId: Constants.Input.appId,
                                                                                   pin: Constants.Input.pin,
                                                                                   encryptedUserKey: Constants.Input.encodedAndEncryptedUserKey,
                                                                                   randomKey: Constants.Input.randomKey)
            XCTAssertEqual(Constants.Output.expectedOriginalRandomKey, result)
        } catch {
            XCTFail("testEncryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice Error")
        }
    }

    // MARK: -
    func testEncryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice() {
        enum Constants {
            enum Input {
                static let softwareTokenKeyFromService: [UInt8] = [-49, 46, 108, -101, -24, -41, 125, 14, 35, 18, -89, -96, 62, -82, 100, -6, -43, -46, -83, 65, -55, 3, 24, -15, 108, 94, 16, -52, 73, 4, -81, -64].map { UInt8(bitPattern: $0) }
                static let symmetricKeyForSoftwareTokenUserKey:[UInt8] = [45, 66, 49, -61, 49, -21, -23, -119, 111, -51, -33, 4, 94, 120, 98, -43, 99, 112, -23, -121, 60, -52, -115, -122, 77, -27, -35, 60, 97, -76, -118, 104].map { UInt8(bitPattern: $0) }
            }
            enum Output {
                static let expectedOutput: [UInt8] = [43, 33, 140, 217, 168, 84, 241, 118, 44, 145, 58, 124, 206, 238, 45, 239, 227, 134, 121, 221, 76, 194, 215, 131, 149, 158, 105, 224, 206, 94, 12, 151]
            }
        }

        do {
            let result = try PLEncryptionHelper.encryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice(softwareTokenKeyFromService: Constants.Input.softwareTokenKeyFromService,
                                                                                                              symmetricKeyForSoftwareTokenUserKey: Constants.Input.symmetricKeyForSoftwareTokenUserKey)
            XCTAssertEqual(Constants.Output.expectedOutput, result)
        } catch {
            XCTFail("testEncryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice Error")
        }
    }

    func testDecryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice() {
        enum Constants {
            enum Input {
                static let encodedAndEncryptedUserKey = "CoKuEJbDEN0B8Txh32I25Zgb4QIVz21BRkZ5X3z3xiM="
                static let symmetricKeyForSoftwareTokenUserKey:[UInt8] = [20, 23, 126, 101, 227, 43, 190, 63, 135, 214, 47, 202, 159, 147, 75, 186, 208, 151, 120, 232, 0, 103, 162, 154, 250, 241, 21, 202, 116, 137, 150, 66]
            }
            enum Output {
                static let softwareTokenKeyFromService: [UInt8] = [178, 81, 18, 17, 101, 244, 202, 240, 54, 167, 228, 162, 79, 115, 22, 34, 245, 96, 224, 211, 87, 127, 100, 228, 231, 100, 108, 27, 87, 241, 101, 102]
            }
        }

        let encryptedUserKey = Data(base64Encoded: Constants.Input.encodedAndEncryptedUserKey)!.bytes

        do {
            let result = try PLEncryptionHelper.decryptSoftwareTokenUserKeyStoredInTrustedDevice(encryptedUserKey: encryptedUserKey,
                                                                                                      symmetricKeyForSoftwareTokenUserKey: Constants.Input.symmetricKeyForSoftwareTokenUserKey)
            print(result)
            XCTAssertEqual(Constants.Output.softwareTokenKeyFromService, result)
        } catch {
            XCTFail("testEncryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice Error")
        }
    }

    func testDecryptSoftTokenUserKeyUsingTrustedDevicePrivateKey() {
        enum Constants {
            enum Input {
                static let encodedSoftwareTokenKey = "iZsPNKxeU/U60oROtFiwlqJSYpbiOxNIXzvJacvJjkoin6sffTgeaYNfzK4qnMl0rdS5NSPfzy06ONmNBIvy1NSmtgVYOVEz+uXKVkpcaeJjG27JADhV2jEJCj3h0k28IybNd5sjBrteCLnxuEVvtqWBJwPr/xaxQkkNsxEG1B/ok2gKA5sXbNXgAYbe8ViA0mIm9tZ4CYdflg1h5nN7l9Vpe9oftgFPgc26/+220NFvSCfIpc1/RfRqyRTEncntupAW4UoSyKlfvYpiW3ewmTRiRRQcrxfBhaD45pysKSDooiblA3kwXmqB3STlbRe4l0D8oCnRKviKf/1JNV1hAA=="

                static let privateKey: SecKey = {
                    let privateKeyBase64 = "MIIEowIBAAKCAQEA0VYHiw9o7YB5guzcqzlHkNiJxCoNlOkPW8qs/ghO7dKPuB36cY1BPlzkf5apEkIAgCuHT1JdINn+a8KSRpKwFgIyfwmf2WwOW/acOQAOjzdSmZLNgWSyh043cB5kMm78P7RpuV3NYfs74V+DJ3lyr7L2qnpsU8lDV0Yy4XXOz1Diks7oPYXag3NI9p27Iuic9IBs1j0ia1I4hONtZVszX3/dW3mwloiDQUXUfGwEkfJ7tz6oeXkHyIKiZZPImZn4LamtI17KBa/i3/cMTMClh1jGC/1KEmmrhl9AiCV+PL5L6R0QhIbKqLFJGQYVn04xJWn+Yuik+Nn9DPy3aZ7vkQIDAQABAoIBAAj8NVSts6ZGFnEdM5eR3NWFxdwKpgyXOFaLS4OX3bNtj0eq2b4X/w3rNM+ZKuaiuJzHwYYRFfg8AySi9F5dG3vGWl6Djj3p2m/uFOSJcRaKnFwFJhcAuH0ASXbhhxF3HBKr7sHLGe6ztu1EiT+fgeGyv82vdYjfIanUVIjC4r6ZOVCZPzsopbGzgJGI29/+6n8G2ySU9BA0z8YqVFAHpj9FNjN4gyh+fppD2DygdAVS78PvEpOrvbMJFbtiGXj6h8H6Q7Oo8W6/FcrvlEVWOlEjnoNiPTi0bArvPdY0dh/Aj3rS/vt3623YzRmvrSC3XEgJYVGpSCoSis1tHArLJTECgYEA6kWoIzl9oqmOyszJf0E6MoEDnSxfIhGu7qJFGKGCAQC4e/LIKgNnOl+ti7WiVP8JnBtYqGdO/061RmUDM96rk+ngmXDsHPew5iDIzLkFVecBNY5o9Ld4XrSgHiw+9DyNWzCxEKC9Njq0Fe9p5QrP9i8+Yhnpwdq+9dEsIaunc00CgYEA5MBQX/ZNH4VUfyk+fd/KCXGip31yjjbLPfctKsdPY24GrYTXJRtOgYJFVQT5Ic6Fwn+ziVTXut4zlJC70mzZB3vAjTJvTOO43RMlOE3ieaNCkts/R1htRfYfh8pDhG4Qbhd62eXjtTaLoQ2xDA0IGsziaMWehxQH1l3Entn6w1UCgYAhmSHXA2zAQl8HOL2BMaKeEaCqDu4J3c1fzgfo02joqejLZfNNCzXnykcCbWc9l2IScF2TsVVECk63LM97xeiHixg6CVbjhKZrKrKBodthCYND4gutZQ6vTmpUSXYx4ulG9cG/J75bI6omJzLhtV5D6VyiByNeOPgAGyKgJZUbVQKBgQDRt874a6NBZseU3YdBd86O4fOxgr1nzKyA3wA13AzYp6LPqp5kkqhi68AMtkaBzAmty84Z9gLie5zmc9r+jHRc/AQIb1jDMXPmmwrgl+cuhZMfeIqHKnbkUUWPBMzpuM6vYC9tXepp1Nwmh5rt5XSsvXJFhAhW5vJYghclW8sfEQKBgC9NCTyOb5twCTQFbzEVh3Bw9I5KZGQAOByp6XzHrxQk78KUQ9O0l1bu1lxI+x7yITYvgExAG/gfc8f0oZr1Pj1RO6DZhCufTgR6XUbZ4zGWnSFo8jZvcgAe93ZwqipjlyZycSth6NqTofOobOsEZAYqEZ4KCNEv5N9dojHNBP6W"
                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
                }()
            }
            enum Output {
                static let expectedOutput = "00b606d89f07ee6f01e9602f57766d67df722b6d6597e03bed0270adb80eca1d7c68e4209b1831613505927d17b21194093a9abe3bbe1b5b8680d7d6a3dd884d1a59ca5a7b370fdc6e2d83da99310c700440a1e287ee76adac8f115b5176915f8afaac2013a45234c72f125988011d1344adc80ff95653b631696daf06c0aa4dad1b9cf4bf6a2edc89337c40360aa51c2ec1532da52e8e4d2bf9a1f45985d725f37875c97d7410cc36b3db6bc46c465724b34c75839485b14b4215613bc57c6d2510129c0c9cde00d5752fbcc7920cd07b9e94648ace4705f3e4852336081134d46ec27a87fe896a3310d262f76fdf4500f0b3b1fb94d7dcf8d8d83bd1c7b06a"
            }
        }

        do {
            let result = try PLEncryptionHelper.decryptSoftTokenUserKeyUsingTrustedDevicePrivateKey(privateKey: Constants.Input.privateKey,
                                                                                                         encodedSoftwareTokenKey: Constants.Input.encodedSoftwareTokenKey)
            XCTAssertEqual(result.toHexString(), Constants.Output.expectedOutput)
        } catch {
            XCTFail("testDecryptSoftTokenUserKeyUsingTrustedDevicePrivateKey Error")
        }
    }

    func testReEncryptUserKey() {
        enum Constants {
            enum Input {
                static let appId = "OneAppd1dd7c5a1ddce9fbae"
                static let pin = "1357"
                static let encodedAndEncryptedUserKey =
                    "iZsPNKxeU/U60oROtFiwlqJSYpbiOxNIXzvJacvJjkoin6sffTgeaYNfzK4qnMl0rdS5NSPfzy06ONmNBIvy1NSmtgVYOVEz+uXKVkpcaeJjG27JADhV2jEJCj3h0k28IybNd5sjBrteCLnxuEVvtqWBJwPr/xaxQkkNsxEG1B/ok2gKA5sXbNXgAYbe8ViA0mIm9tZ4CYdflg1h5nN7l9Vpe9oftgFPgc26/+220NFvSCfIpc1/RfRqyRTEncntupAW4UoSyKlfvYpiW3ewmTRiRRQcrxfBhaD45pysKSDooiblA3kwXmqB3STlbRe4l0D8oCnRKviKf/1JNV1hAA=="
                static let privateKey: SecKey = {
                    let privateKeyBase64 = "MIIEowIBAAKCAQEA0VYHiw9o7YB5guzcqzlHkNiJxCoNlOkPW8qs/ghO7dKPuB36cY1BPlzkf5apEkIAgCuHT1JdINn+a8KSRpKwFgIyfwmf2WwOW/acOQAOjzdSmZLNgWSyh043cB5kMm78P7RpuV3NYfs74V+DJ3lyr7L2qnpsU8lDV0Yy4XXOz1Diks7oPYXag3NI9p27Iuic9IBs1j0ia1I4hONtZVszX3/dW3mwloiDQUXUfGwEkfJ7tz6oeXkHyIKiZZPImZn4LamtI17KBa/i3/cMTMClh1jGC/1KEmmrhl9AiCV+PL5L6R0QhIbKqLFJGQYVn04xJWn+Yuik+Nn9DPy3aZ7vkQIDAQABAoIBAAj8NVSts6ZGFnEdM5eR3NWFxdwKpgyXOFaLS4OX3bNtj0eq2b4X/w3rNM+ZKuaiuJzHwYYRFfg8AySi9F5dG3vGWl6Djj3p2m/uFOSJcRaKnFwFJhcAuH0ASXbhhxF3HBKr7sHLGe6ztu1EiT+fgeGyv82vdYjfIanUVIjC4r6ZOVCZPzsopbGzgJGI29/+6n8G2ySU9BA0z8YqVFAHpj9FNjN4gyh+fppD2DygdAVS78PvEpOrvbMJFbtiGXj6h8H6Q7Oo8W6/FcrvlEVWOlEjnoNiPTi0bArvPdY0dh/Aj3rS/vt3623YzRmvrSC3XEgJYVGpSCoSis1tHArLJTECgYEA6kWoIzl9oqmOyszJf0E6MoEDnSxfIhGu7qJFGKGCAQC4e/LIKgNnOl+ti7WiVP8JnBtYqGdO/061RmUDM96rk+ngmXDsHPew5iDIzLkFVecBNY5o9Ld4XrSgHiw+9DyNWzCxEKC9Njq0Fe9p5QrP9i8+Yhnpwdq+9dEsIaunc00CgYEA5MBQX/ZNH4VUfyk+fd/KCXGip31yjjbLPfctKsdPY24GrYTXJRtOgYJFVQT5Ic6Fwn+ziVTXut4zlJC70mzZB3vAjTJvTOO43RMlOE3ieaNCkts/R1htRfYfh8pDhG4Qbhd62eXjtTaLoQ2xDA0IGsziaMWehxQH1l3Entn6w1UCgYAhmSHXA2zAQl8HOL2BMaKeEaCqDu4J3c1fzgfo02joqejLZfNNCzXnykcCbWc9l2IScF2TsVVECk63LM97xeiHixg6CVbjhKZrKrKBodthCYND4gutZQ6vTmpUSXYx4ulG9cG/J75bI6omJzLhtV5D6VyiByNeOPgAGyKgJZUbVQKBgQDRt874a6NBZseU3YdBd86O4fOxgr1nzKyA3wA13AzYp6LPqp5kkqhi68AMtkaBzAmty84Z9gLie5zmc9r+jHRc/AQIb1jDMXPmmwrgl+cuhZMfeIqHKnbkUUWPBMzpuM6vYC9tXepp1Nwmh5rt5XSsvXJFhAhW5vJYghclW8sfEQKBgC9NCTyOb5twCTQFbzEVh3Bw9I5KZGQAOByp6XzHrxQk78KUQ9O0l1bu1lxI+x7yITYvgExAG/gfc8f0oZr1Pj1RO6DZhCufTgR6XUbZ4zGWnSFo8jZvcgAe93ZwqipjlyZycSth6NqTofOobOsEZAYqEZ4KCNEv5N9dojHNBP6W"
                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
                }()
            }
            enum Output {
                static let expectedOutput: [UInt8] = [247, 51, 221, 61, 119, 225, 185, 130, 111, 252, 199, 122, 84, 41, 159, 95, 239, 198, 46, 151, 129, 93, 78, 220, 62, 9, 188, 54, 114, 64, 103, 99]
            }
        }

        do {
            let result = try PLEncryptionHelper.reEncryptUserKey(Constants.Input.appId,
                                                                      pin: Constants.Input.pin,
                                                                      privateKey: Constants.Input.privateKey,
                                                                      encryptedUserKey: Constants.Input.encodedAndEncryptedUserKey)
            XCTAssertEqual(result, Constants.Output.expectedOutput.toBase64())
        } catch {
            XCTFail("testDecryptSoftTokenUserKeyUsingTrustedDevicePrivateKey Error")
        }
    }
}


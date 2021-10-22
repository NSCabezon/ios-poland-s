//
//  PLTrustedDeviceUserKeyEncryptionUseCaseTest.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 6/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Commons
import DomainCommon
import CryptoSwift
@testable import PLLogin

class PLTrustedDeviceUserKeyEncryptionUseCaseTest: XCTestCase {

    private let dependencies = DependenciesDefault()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // MARK:-
    func testReencryption() throws {
        enum Constants {
            enum Input {
                static let tokens: [TrustedDeviceSoftwareToken] =
                    [TrustedDeviceSoftwareToken(name: "06783937046561403484",
                                                key: "iZsPNKxeU/U60oROtFiwlqJSYpbiOxNIXzvJacvJjkoin6sffTgeaYNfzK4qnMl0rdS5NSPfzy06ONmNBIvy1NSmtgVYOVEz+uXKVkpcaeJjG27JADhV2jEJCj3h0k28IybNd5sjBrteCLnxuEVvtqWBJwPr/xaxQkkNsxEG1B/ok2gKA5sXbNXgAYbe8ViA0mIm9tZ4CYdflg1h5nN7l9Vpe9oftgFPgc26/+220NFvSCfIpc1/RfRqyRTEncntupAW4UoSyKlfvYpiW3ewmTRiRRQcrxfBhaD45pysKSDooiblA3kwXmqB3STlbRe4l0D8oCnRKviKf/1JNV1hAA==",
                                                type: "PIN",
                                                state: "PENDING",
                                                id: 516194,
                                                timestamp: 0),
                     TrustedDeviceSoftwareToken(name: "06783937046561403484",
                                                key: "iZsPNKxeU/U60oROtFiwlqJSYpbiOxNIXzvJacvJjkoin6sffTgeaYNfzK4qnMl0rdS5NSPfzy06ONmNBIvy1NSmtgVYOVEz+uXKVkpcaeJjG27JADhV2jEJCj3h0k28IybNd5sjBrteCLnxuEVvtqWBJwPr/xaxQkkNsxEG1B/ok2gKA5sXbNXgAYbe8ViA0mIm9tZ4CYdflg1h5nN7l9Vpe9oftgFPgc26/+220NFvSCfIpc1/RfRqyRTEncntupAW4UoSyKlfvYpiW3ewmTRiRRQcrxfBhaD45pysKSDooiblA3kwXmqB3STlbRe4l0D8oCnRKviKf/1JNV1hAA==",
                                                type: "BIOMETRICS",
                                                state: "PENDING",
                                                id: 516195,
                                                timestamp: 0)]
                static let appId = "OneAppd1dd7c5a1ddce9fbae"
                static let pin = "1357"
                static let privateKey: SecKey = {
                    let privateKeyBase64 = "MIIEowIBAAKCAQEA0VYHiw9o7YB5guzcqzlHkNiJxCoNlOkPW8qs/ghO7dKPuB36cY1BPlzkf5apEkIAgCuHT1JdINn+a8KSRpKwFgIyfwmf2WwOW/acOQAOjzdSmZLNgWSyh043cB5kMm78P7RpuV3NYfs74V+DJ3lyr7L2qnpsU8lDV0Yy4XXOz1Diks7oPYXag3NI9p27Iuic9IBs1j0ia1I4hONtZVszX3/dW3mwloiDQUXUfGwEkfJ7tz6oeXkHyIKiZZPImZn4LamtI17KBa/i3/cMTMClh1jGC/1KEmmrhl9AiCV+PL5L6R0QhIbKqLFJGQYVn04xJWn+Yuik+Nn9DPy3aZ7vkQIDAQABAoIBAAj8NVSts6ZGFnEdM5eR3NWFxdwKpgyXOFaLS4OX3bNtj0eq2b4X/w3rNM+ZKuaiuJzHwYYRFfg8AySi9F5dG3vGWl6Djj3p2m/uFOSJcRaKnFwFJhcAuH0ASXbhhxF3HBKr7sHLGe6ztu1EiT+fgeGyv82vdYjfIanUVIjC4r6ZOVCZPzsopbGzgJGI29/+6n8G2ySU9BA0z8YqVFAHpj9FNjN4gyh+fppD2DygdAVS78PvEpOrvbMJFbtiGXj6h8H6Q7Oo8W6/FcrvlEVWOlEjnoNiPTi0bArvPdY0dh/Aj3rS/vt3623YzRmvrSC3XEgJYVGpSCoSis1tHArLJTECgYEA6kWoIzl9oqmOyszJf0E6MoEDnSxfIhGu7qJFGKGCAQC4e/LIKgNnOl+ti7WiVP8JnBtYqGdO/061RmUDM96rk+ngmXDsHPew5iDIzLkFVecBNY5o9Ld4XrSgHiw+9DyNWzCxEKC9Njq0Fe9p5QrP9i8+Yhnpwdq+9dEsIaunc00CgYEA5MBQX/ZNH4VUfyk+fd/KCXGip31yjjbLPfctKsdPY24GrYTXJRtOgYJFVQT5Ic6Fwn+ziVTXut4zlJC70mzZB3vAjTJvTOO43RMlOE3ieaNCkts/R1htRfYfh8pDhG4Qbhd62eXjtTaLoQ2xDA0IGsziaMWehxQH1l3Entn6w1UCgYAhmSHXA2zAQl8HOL2BMaKeEaCqDu4J3c1fzgfo02joqejLZfNNCzXnykcCbWc9l2IScF2TsVVECk63LM97xeiHixg6CVbjhKZrKrKBodthCYND4gutZQ6vTmpUSXYx4ulG9cG/J75bI6omJzLhtV5D6VyiByNeOPgAGyKgJZUbVQKBgQDRt874a6NBZseU3YdBd86O4fOxgr1nzKyA3wA13AzYp6LPqp5kkqhi68AMtkaBzAmty84Z9gLie5zmc9r+jHRc/AQIb1jDMXPmmwrgl+cuhZMfeIqHKnbkUUWPBMzpuM6vYC9tXepp1Nwmh5rt5XSsvXJFhAhW5vJYghclW8sfEQKBgC9NCTyOb5twCTQFbzEVh3Bw9I5KZGQAOByp6XzHrxQk78KUQ9O0l1bu1lxI+x7yITYvgExAG/gfc8f0oZr1Pj1RO6DZhCufTgR6XUbZ4zGWnSFo8jZvcgAe93ZwqipjlyZycSth6NqTofOobOsEZAYqEZ4KCNEv5N9dojHNBP6W"
                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
                }()
            }
            enum Output {
                enum EncryptedKeys {
                    static let PIN = "9zPdPXfhuYJv/Md6VCmfX+/GLpeBXU7cPgm8NnJAZ2M="
                    static let BIOMETRICS = "znXk3ATe8jTcUPuGPKo5ftC5pMIRpUwhOqjGAue7GF4="
                }
            }
        }

        do {
            let useCase = PLTrustedDeviceUserKeyReEncryptionUseCase(dependenciesResolver: self.dependencies)
            let input = PLTrustedDeviceUserKeyReEncryptionUseCaseInput(appId: Constants.Input.appId,
                                                                       pin: Constants.Input.pin,
                                                                       privateKey: Constants.Input.privateKey,
                                                                       tokens: Constants.Input.tokens)
            let response = try useCase.executeUseCase(requestValues: input)
            let result = try response.getOkResult()

            XCTAssertEqual(result.reEncryptedUserKeyPIN, Constants.Output.EncryptedKeys.PIN)
            XCTAssertEqual(result.reEncryptedUserKeyBiometrics, Constants.Output.EncryptedKeys.BIOMETRICS)
        } catch {
            XCTFail("testReencryption Error")
        }
    }

    func testReencryption2() throws {
        enum Constants {
            enum Input {
                static let tokens: [TrustedDeviceSoftwareToken] =
                    [TrustedDeviceSoftwareToken(name: "12078369742237577820",
                                                key: "Kmtny/NCV3Ytu89vYdgWKxLm8UXz5ZxNTtSvc5Ym78xcdF1FPCz/2ux5tUEwXphi7H5p6uSzZm2m44zTLdpr3UbQzVIWb2QNHGEHLhWihkT7ErRbHjQpfzFj3ZtKAjqq3DYJ3WLvr83GaQB/Vj7WjcwktuPuh85dIwW79xkHcUrvMWHwbNnBWqabvbRqQMPxZ6cOjrrOn34x3AOFFgyyYpxa6y/KALDYdORK5jCD+6ZzrRAqCe6KCi+4q6MfeFeyZ2OPScLCmxnkOQva102whldIUeo3x4LmLnAnoJXmbKYrWLShjAxapiQmp3vTA8ALaH8mfr8Vqzd3odyzXi6Ckg==",
                                                type: "PIN",
                                                state: "PENDING",
                                                id: 158171,
                                                timestamp: 363327891),
                     TrustedDeviceSoftwareToken(name: "15537134256058118748",
                                                key: "VIt9o0PpViP9yiaL1bb/INnmaIJTfil2HDnHotEfh2LiYFxJeAbktS3+nHsyFvf0FxbyP5d1Fr+bc9JhBktCklKo2WFdn9HNafWbGukOy9ZRNDOBbv5YKFSJ72OgS8AqkProhNLspBOiwTLequnjc78pBp8Ez+7EUDTBeieofjyDtmePdxX1bAjmnmgrDXa3zjhm4UND6WD/6TMRJIC/8QJaBjMbgnPRnbyUZzn7hPNOu96bqYrt9Y4FIiAauKGT25n56imN/gQ1rxhxizFdY8uv4/KLs/TKmI7rIwqTqjTr1FZ1UYyNdVHdORm4o1BakUq/NU05uqCN3Pc49zAVhA==",
                                                type: "BIOMETRICS",
                                                state: "PENDING",
                                                id: 158172,
                                                timestamp: 363330441)]
                static let appId = "OneAppd1dd7c5a1ddce9fbae"
                static let pin = "1357"
                static let privateKey: SecKey = {
                    let privateKeyBase64 =
                    "MIIEowIBAAKCAQEAs4uhHl8DHo+S6K4wmu7TwfXJ+riXUZPU5JuVFL8sk60N7t/zuWUqkAMg3DZmvmMF3320P/Hyv+aCJ3Lo0Ez8mwcM037Oa4janAlRfqakUzcvNHmsT066eVfK5YO9LY7H0yaae5LRiO9LZmgdzA6Rry0Vx64NQVAUU0Z6Uo2LvHxfb9iwq05c1EkmjMzfAp0xU83rkMI2lHCs9k2H4aLipAYGNfHsGVO0NOYvO7wnsEDyh8lGovAX4PCYJIOlVVorHu01XbPHxaZQPVdjT1NP8JkYEWSApCmXqfSJz2PfXkGKpulnHHI2SEpeJYqgpCgyVAj3gJxGcGDgbI7JuZiaPwIDAQABAoIBAAHWVQp+qFTTCVo4u1RjXLHX9RAMAU2h6lGTKmeBvL5Y3m/Es7oJYpDe91L6GVOZ9vkBqNdaQaFgqRXyqzVIHTimIdHP8LdIbmTK6a/QKJYIlC7xJMKEX9vW1xvXpdB6FLmoi75YhdkRJNOMIQ8rSKbELE38S+TFi6BALZ2AKJrclf3HkBCZtjANvfvoXWwe10hIwzOcDzAXkLL1G0nmYbQzGbCM+cmgDwo537kXAzPZa4N8+Ih7jMxxRKV1vRufGCZOM5Jy7DLGxsKV1Bu/6s2OJSyZZESqPuVeQ2778AWSNmZQQk5yWGBjZ4yIELJzdoxL0kI4KWJJuViz4QYJWgECgYEA6ZAG3zhnYjEot6UFKFrNhxanDRHijEAtxMVlVr/zezxSZ0Jz6dSz4yI68NEyFQeJFxaDdo3aGm4uicGF0Sqon/CjlXvQ1nheOPvK7uQ7VwTY2ocRgAL7HbgcjjW4K+Dl2ADQ8yMnKNC6VYQ6V6kk7wtyIgFMhvre+vva4YjbGSECgYEAxMsqXH8STSfJdkdlljGcB471M+pAo0S7E1n4w0FFdXqB/B9jUPCESdRmXdMQmHbUHKYph6fnbesfyNfrQyrGN+2ghdWCJ+Lx49+MAXP7ddTaeQs9gTam9OEhmhWKYe7ePIE5SFgwVTC46qRo040Qd0qiIHx9+Iw5vi6ugl1uZ18CgYAR9jGRGRVaR82J0fcDk3ga23MdXjK99nGOoF+avEhNQeZUapffc6wh25AM1Qm09E9mpySVCXOsdKy/i1JvM4ikRC1QYaU92SPl3fdNR+AIYScMJzcBUTlen7oSda8kMLd8VRO8nwdz7BloWjLiau+cMpUkaFUqTEC5rIS4s32mAQKBgDfT6xCSe/6nat/DIW6aZElApQ81RWEL/oZe39OEkM/jET0VKnerw9uuBdxYJD0ceNAn02BIob7tFPdFSdikKddz8jYFfAcUusqKgI1o+c1TtSbhqXEer/6IX5/2vGtL+H/xqO59FjkUuWDXg2WAf0tYQOY2awY3wanSVG9nUgrBAoGBAKZuDc/K0qp93KLNKSMZqL5DOul9Q/SvuwF7j7Q0EhANMLnBcNTzqkqWn6yeqY5LRXOOKW2QsNyeW4F2ffYGRAFsSg6Sxs0QxrcW0c61QtsAi8hs+GisMKBDFRgkHRZTwyExm9grAFIjNw7msdC95lzKO3ypJIin9yCnU1bktOlt"
                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
                }()
            }
            enum Output {
                enum EncryptedKeys {
                    static let PIN = "MO1/ztlgGbKqZwovBHR599tayXHQ1Ir06QhEu/l3YCE="
                    static let BIOMETRICS = "CugpVSsxKTCv4f4gDlHJlTfUitU/BPhAOR3KJ8g5F5A="
                }
            }
        }

        do {

            let useCase = PLTrustedDeviceUserKeyReEncryptionUseCase(dependenciesResolver: self.dependencies)
            let input = PLTrustedDeviceUserKeyReEncryptionUseCaseInput(appId: Constants.Input.appId,
                                                                       pin: Constants.Input.pin,
                                                                       privateKey: Constants.Input.privateKey,
                                                                       tokens: Constants.Input.tokens)
            let response = try useCase.executeUseCase(requestValues: input)
            let result = try response.getOkResult()

            XCTAssertEqual(result.reEncryptedUserKeyPIN, Constants.Output.EncryptedKeys.PIN)
            XCTAssertEqual(result.reEncryptedUserKeyBiometrics, Constants.Output.EncryptedKeys.BIOMETRICS)
        } catch {
            XCTFail("testReencryption Error")
        }
    }
}
//
//    //MARK:-
//    func testSymetricKey() {
//        enum Constants {
//            enum Input {
//                static let appId = "OneApp651d4c6360bd538cf4"
//                static let pin = "1357"
//            }
//            enum Output {
//                static let symetricKey: Array<UInt8> =  [45, 66, 49, -61, 49, -21, -23, -119, 111, -51, -33, 4, 94, 120, 98, -43, 99, 112, -23, -121, 60, -52, -115, -122, 77, -27, -35, 60, 97, -76, -118, 104].map { UInt8(bitPattern: $0) }
//            }
//        }
//
//        do {
//            let result = try PLLoginUserKeyReEncryptionUseCase.createSymmetricKeyForSoftwareTokenUserKeyUsage(trustedDeviceAppId: Constants.Input.appId,
//                                                                                                              pin: Constants.Input.pin)
//            XCTAssertEqual(result, Constants.Output.symetricKey)
//        } catch {
//            XCTFail("testSymetricKey Error")
//        }
//    }
//
//    //MARK:-
//    func testCalculateHash() {
//        enum Constants {
//            enum Input {
//                static let randomKey: [UInt8] = [-103, 54, 64, -73, 33, 55, -13, 3, 22, 85, 56, 90, -60, -15, 63, 83, 58, 96, 14, 3, 76, -125, -38, -2, 66, 119, 73, 58, -68, 82, 49, 72].map { UInt8(bitPattern: $0) }
//            }
//            enum Output {
//                static let expectedOutput: Array<UInt8> =  [-89, 114, -127, 65, -90, -54, 111, 118, -90, 33, -94, -44, -104, 64, 101, -93, 56, 15, 82, -123, 126, 48, -34, -85, 79, 58, 92, 46, -1, 16, -87, 83].map { UInt8(bitPattern: $0) }
//            }
//        }
//
//        let result = PLLoginUserKeyReEncryptionUseCase.calculateHash(randomKey: Constants.Input.randomKey)
//        XCTAssertEqual(result, Constants.Output.expectedOutput)
//    }
//
//    // MARK: -
//    func testCreateInitialiationVector() {
//        enum Constants {
//            enum Input {
//                static let appId = "OneApp651d4c6360bd538cf4"
//            }
//            enum Output {
//                static let expectedIV = "FEEA00651D4C6360BD538CF400000000"
//            }
//        }
//
//        do {
//            let vector = try PLLoginUserKeyReEncryptionUseCase.createInitializationVectorByTrustedDeviceAppId(appId: Constants.Input.appId)
//            XCTAssertEqual(vector.toHexString().uppercased(), Constants.Output.expectedIV)
//        } catch {
//            XCTFail("testCreateInitialiationVector Error")
//        }
//    }
//
//    // MARK: -
//    func testCalculateAuthorizationData() {
//        enum Constants {
//
//            enum Input {
//                static let randomKey: [UInt8] =
//                    [-103, 54, 64, -73, 33, 55, -13, 3, 22, 85, 56, 90, -60, -15, 63, 83, 58, 96, 14, 3, 76, -125, -38, -2, 66, 119, 73, 58, -68, 82, 49, 72].map { UInt8(bitPattern: $0) }
//                static let challenge = "15712338"
//                static let privateKey: SecKey = {
//                    let privateKeyBase64 = "MIIEogIBAAKCAQEAs0UFMJEEtkFFAZzOcBQEE7DNtSQI5VECDV6FQNkwkTfvy8va+ERKBUk/EdbUPmOmaWZvpPmyjP50QuDMVTpo86+dwnl4Qym+ZW/hYN2LZEgnn/yfUNlpP5hkU77oDdcB+FsrsbU08dLEYyl9bi0I1DjPJbZgG4Gx5JDYR/5plIUR7xJH+IFI+EFXx014Snrc+MsFsnMUIjwoC3N7C9mCTGMHa5bm7XRy1FSLlyQNDPDy5wOaS/np+Gc5M5ICp9JrfWyMY+KGPGuGZCSlB66HJy4OuhcZW38UYabA6YIj0HGaZQj0HSah4DDvwjuL8QmYGaVK/BY4w+C3II3otCEwAQIDAQABAoIBAFZGPT0mTZI4zzD7eg5OU7f2OsmWUgGqfsZYWuDepZT9ypXVwcgBdW4d1hCLxxFPe+L1vX0z/k4El4coEK5jsea0+cOCGfKYwFyo/1pSxKa6YveH6FRMjW5htMbo9VzTwMr5dYnMn3JR8NmYOhkv6zPXMzn/DzmtrSNG4g+jzMQAh8wBggc6J1CsE2dmwQ4vlbbdir+7LHdZGJfUSZWGkohtqH6pY4Q34pEleFl3ziKcniWULUdLBHDyg3xTpn2nDoo/nXfAFQJ9OZM170ztiyfLYieteOiLV1xMJI5sBBlvw9dhnTeh1z+D5aelJigkWYElQdbENg7/bopT4xBTWdECgYEA5+oktJWYvy4+/4S6O+MIt9EqZEiFwPeqviavOH/XjEOA//U+ZwON2ypQ4xoTw+yCiGH0wIztmpkJ+ew4kiujJ0YFxz+GahqYL3mJH0o+gzXh7Xjafd7RDGxuBbnAmeZn7tKTeBwZKbNX0jtb1yDi3CFZuOSFJXoErcDmft9x9acCgYEAxeM3jQRU05hv+/YhiKknPsiaezCsMe6vzY8UcPWnLwWaLD6Vx3UO1BvXnwRRlFUaOUhLP3gCLr5nHRF2Lpl9UJuscimKudWj+FZeVbLQaIvJLQPxT/P+MTGMfQZCR/64XPolUbjrUtPU0fsEWLoeWDAEo5+3Ju/ydWiYVmn6shcCgYBEv+CJuB9D7Y23ab1bq34WH+eVOvqLrd/r5sPi1+MqLYi8WBNbrm4LHoxEBqL9XcuEaqWHvz9gqSWP9Tr/+fev2M41tts98QxUZo8Du5q0gvCq2TzMO5V1PV+QSvSRqv/8iGg3Hv1Go2fRZs9fAty9rRVP/k6KQZXJfHnX+p1p2QKBgAVVGBwer8J76xiZC1JJbJtOgIstRpaZ3fbmEiDxHa4wsnTawuJ7Dwk8LtVEIoaivHAquIxfSX/E9bZc0Bh1XmEbsMvqvqg/T4nTmfspNGB809D4uDn1UzY0JZsA3ixees1WmEbZes3ik2uNHhLeAQ9TS+y00xSjhp8PUHuTo4PFAoGAb48A/e71NUk3udpNj3LbIw989mZijVFrKzSf3+I6+7BVjWJte079R9AxTbGlzUDulkVC7ERIpqPbyvB65CrPRC3UJM+q1ub+Kf2FADZD9Htcmbbi82bOqgIMrCPwDMGVav4ubE0e4p+TmwxDen2oQJTXLh0JmxAPOttHqaaefto=" // 2048
//                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
//                }()
//            }
//            enum Output {
//                static let expectedOutput =
//                    "p3KBQabKb3amIaLUmEBlozgPUoV+MN6rTzpcLv8QqVMSOEO0lMf5EGphn4l9Abpo8/3tgCmURRY3AN6gqS4/6OahB3oEqQ3sqk0JnkU8J8jxnWdx8SO4atc5SmfqNets0J1WkZj6RksmXVcPKNOYuHG7GOZycpJqvgk4fTMlNdJKU5JOAcey4lRmzcUGdIxADIlpedi71Kbg0thlsBaygXQsxtE7RSKGzDwtpeq1skq+8Lr78vSkpsj1TNlShoPKSkmN+e0rKwhGi/b6LSMC5lpspd2+LP9I7AyuFkXtw82ynXzoYyRrwHTHorGr4NPu0riUNN2zGksP2kUqXi8iITzBPaiMw60N8s4Hzn6PGT6e8O03m4XoUUwcOcZ38id9"
//            }
//        }
//
//        do {
//            let result = try PLLoginUserKeyReEncryptionUseCase.calculateAuthorizationData(randomKey: Constants.Input.randomKey,
//                                                                                          challenge: Constants.Input.challenge,
//                                                                                          privateKey: Constants.Input.privateKey)
//            XCTAssertEqual(result, Constants.Output.expectedOutput)
//        } catch {
//            XCTFail("testCalculateAuthorizationData Error")
//        }
//    }
//
//    // MARK: -
//    func testGetRandomKeyFromSoftwareToken() {
//        enum Constants {
//            enum Input {
//                static let appId = "OneApp404e977d770d9f19ba"
//                static let pin = "1357"
//                static let randomKey = "yZEwic5MEfBr+jtoeLDWOVwHmLngs47QNNyDAHrEVD0="
//                static let encodedAndEncryptedUserKey = "CoKuEJbDEN0B8Txh32I25Zgb4QIVz21BRkZ5X3z3xiM="
//            }
//            enum Output {
//                static let expectedOriginalRandomKey = "E25BEE258EA868F1A8E67E7C04861907C2DE2B97AD53EC0ABD97173917ACB46B"
//            }
//        }
//
//        do {
//            guard let encryptedUserKey = Data(base64Encoded: Constants.Input.encodedAndEncryptedUserKey)?.bytes else { throw NSError() }
//            let result = try PLLoginUserKeyReEncryptionUseCase.getRandomKeyFromSoftwareToken(appId: Constants.Input.appId,
//                                                                                             pin: Constants.Input.pin,
//                                                                                             encryptedUserKey: encryptedUserKey,
//                                                                                             randomKey: Constants.Input.randomKey)
//            XCTAssertEqual(Constants.Output.expectedOriginalRandomKey, result.toHexString().uppercased())
//        } catch {
//            XCTFail("testEncryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice Error")
//        }
//    }
//
//    // MARK: -
//    func testEncryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice() {
//        enum Constants {
//            enum Input {
//                static let softwareTokenKeyFromService: [UInt8] = [-49, 46, 108, -101, -24, -41, 125, 14, 35, 18, -89, -96, 62, -82, 100, -6, -43, -46, -83, 65, -55, 3, 24, -15, 108, 94, 16, -52, 73, 4, -81, -64].map { UInt8(bitPattern: $0) }
//                static let symmetricKeyForSoftwareTokenUserKey:[UInt8] = [45, 66, 49, -61, 49, -21, -23, -119, 111, -51, -33, 4, 94, 120, 98, -43, 99, 112, -23, -121, 60, -52, -115, -122, 77, -27, -35, 60, 97, -76, -118, 104].map { UInt8(bitPattern: $0) }
//            }
//            enum Output {
//                static let expectedOutput: [UInt8] = [43, 33, 140, 217, 168, 84, 241, 118, 44, 145, 58, 124, 206, 238, 45, 239, 227, 134, 121, 221, 76, 194, 215, 131, 149, 158, 105, 224, 206, 94, 12, 151]
//            }
//        }
//
//        do {
//            let result = try PLLoginUserKeyReEncryptionUseCase.encryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice(softwareTokenKeyFromService: Constants.Input.softwareTokenKeyFromService,
//                                                                                                                        symmetricKeyForSoftwareTokenUserKey: Constants.Input.symmetricKeyForSoftwareTokenUserKey)
//            XCTAssertEqual(Constants.Output.expectedOutput, result)
//        } catch {
//            XCTFail("testEncryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice Error")
//        }
//    }
//
//    func testDecryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice() {
//        enum Constants {
//            enum Input {
//                static let encodedAndEncryptedUserKey = "CoKuEJbDEN0B8Txh32I25Zgb4QIVz21BRkZ5X3z3xiM="
//                static let symmetricKeyForSoftwareTokenUserKey:[UInt8] = [20, 23, 126, 101, 227, 43, 190, 63, 135, 214, 47, 202, 159, 147, 75, 186, 208, 151, 120, 232, 0, 103, 162, 154, 250, 241, 21, 202, 116, 137, 150, 66]
//            }
//            enum Output {
//                static let softwareTokenKeyFromService: [UInt8] = [178, 81, 18, 17, 101, 244, 202, 240, 54, 167, 228, 162, 79, 115, 22, 34, 245, 96, 224, 211, 87, 127, 100, 228, 231, 100, 108, 27, 87, 241, 101, 102]
//            }
//        }
//
//        let encryptedUserKey = Data(base64Encoded: Constants.Input.encodedAndEncryptedUserKey)!.bytes
//
//        do {
//            let result = try PLLoginUserKeyReEncryptionUseCase.decryptSoftwareTokenUserKeyStoredInTrustedDevice(encryptedUserKey: encryptedUserKey,
//                                                                                                                symmetricKeyForSoftwareTokenUserKey: Constants.Input.symmetricKeyForSoftwareTokenUserKey)
//            print(result)
//            XCTAssertEqual(Constants.Output.softwareTokenKeyFromService, result)
//        } catch {
//            XCTFail("testEncryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice Error")
//        }
//    }
//
//    func testDecryptSoftTokenUserKeyUsingTrustedDevicePrivateKey() {
//        enum Constants {
//            enum Input {
////                static let encodedSoftwareTokenKey =
////                    "k0qtzUuefhS9Vy2tjmakBgD4dmo7oiOfiLrGQoVmVvtUaOeWWsh+m36VBa/GJHfZXVHfKQn1Lnw/46v6A/r46CPwMuF1rZed79UbHNWPj+9pzQmf7iMV6ia5mTWWafu/hrHAMDkWqwCB4o15heQ7YLVftGJ0TTe6gr6rzy+1Bg+lemlhtpFdgTBuafwFxdUNzK4BQRNIOynUAB1rfAFnnuNjSswxD5QzyBaAgnSYHChtqzuqcQkywZJ4pQayhZTY8IjS0gD7Co9DKR1CXfxwR1mS2i/CAjBmMhI1IwEdU1TLT8zIpfK0pDQ3Rz2EY+cggSX7gZvd32Q9DXL/VApsLA=="
//
//                // Llamada real iOS
//                static let encodedSoftwareTokenKey = "iZsPNKxeU/U60oROtFiwlqJSYpbiOxNIXzvJacvJjkoin6sffTgeaYNfzK4qnMl0rdS5NSPfzy06ONmNBIvy1NSmtgVYOVEz+uXKVkpcaeJjG27JADhV2jEJCj3h0k28IybNd5sjBrteCLnxuEVvtqWBJwPr/xaxQkkNsxEG1B/ok2gKA5sXbNXgAYbe8ViA0mIm9tZ4CYdflg1h5nN7l9Vpe9oftgFPgc26/+220NFvSCfIpc1/RfRqyRTEncntupAW4UoSyKlfvYpiW3ewmTRiRRQcrxfBhaD45pysKSDooiblA3kwXmqB3STlbRe4l0D8oCnRKviKf/1JNV1hAA=="
//
//                static let privateKey: SecKey = {
//                    let privateKeyBase64 = "MIIEowIBAAKCAQEA0VYHiw9o7YB5guzcqzlHkNiJxCoNlOkPW8qs/ghO7dKPuB36cY1BPlzkf5apEkIAgCuHT1JdINn+a8KSRpKwFgIyfwmf2WwOW/acOQAOjzdSmZLNgWSyh043cB5kMm78P7RpuV3NYfs74V+DJ3lyr7L2qnpsU8lDV0Yy4XXOz1Diks7oPYXag3NI9p27Iuic9IBs1j0ia1I4hONtZVszX3/dW3mwloiDQUXUfGwEkfJ7tz6oeXkHyIKiZZPImZn4LamtI17KBa/i3/cMTMClh1jGC/1KEmmrhl9AiCV+PL5L6R0QhIbKqLFJGQYVn04xJWn+Yuik+Nn9DPy3aZ7vkQIDAQABAoIBAAj8NVSts6ZGFnEdM5eR3NWFxdwKpgyXOFaLS4OX3bNtj0eq2b4X/w3rNM+ZKuaiuJzHwYYRFfg8AySi9F5dG3vGWl6Djj3p2m/uFOSJcRaKnFwFJhcAuH0ASXbhhxF3HBKr7sHLGe6ztu1EiT+fgeGyv82vdYjfIanUVIjC4r6ZOVCZPzsopbGzgJGI29/+6n8G2ySU9BA0z8YqVFAHpj9FNjN4gyh+fppD2DygdAVS78PvEpOrvbMJFbtiGXj6h8H6Q7Oo8W6/FcrvlEVWOlEjnoNiPTi0bArvPdY0dh/Aj3rS/vt3623YzRmvrSC3XEgJYVGpSCoSis1tHArLJTECgYEA6kWoIzl9oqmOyszJf0E6MoEDnSxfIhGu7qJFGKGCAQC4e/LIKgNnOl+ti7WiVP8JnBtYqGdO/061RmUDM96rk+ngmXDsHPew5iDIzLkFVecBNY5o9Ld4XrSgHiw+9DyNWzCxEKC9Njq0Fe9p5QrP9i8+Yhnpwdq+9dEsIaunc00CgYEA5MBQX/ZNH4VUfyk+fd/KCXGip31yjjbLPfctKsdPY24GrYTXJRtOgYJFVQT5Ic6Fwn+ziVTXut4zlJC70mzZB3vAjTJvTOO43RMlOE3ieaNCkts/R1htRfYfh8pDhG4Qbhd62eXjtTaLoQ2xDA0IGsziaMWehxQH1l3Entn6w1UCgYAhmSHXA2zAQl8HOL2BMaKeEaCqDu4J3c1fzgfo02joqejLZfNNCzXnykcCbWc9l2IScF2TsVVECk63LM97xeiHixg6CVbjhKZrKrKBodthCYND4gutZQ6vTmpUSXYx4ulG9cG/J75bI6omJzLhtV5D6VyiByNeOPgAGyKgJZUbVQKBgQDRt874a6NBZseU3YdBd86O4fOxgr1nzKyA3wA13AzYp6LPqp5kkqhi68AMtkaBzAmty84Z9gLie5zmc9r+jHRc/AQIb1jDMXPmmwrgl+cuhZMfeIqHKnbkUUWPBMzpuM6vYC9tXepp1Nwmh5rt5XSsvXJFhAhW5vJYghclW8sfEQKBgC9NCTyOb5twCTQFbzEVh3Bw9I5KZGQAOByp6XzHrxQk78KUQ9O0l1bu1lxI+x7yITYvgExAG/gfc8f0oZr1Pj1RO6DZhCufTgR6XUbZ4zGWnSFo8jZvcgAe93ZwqipjlyZycSth6NqTofOobOsEZAYqEZ4KCNEv5N9dojHNBP6W"
//                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
//                }()
//            }
//            enum Output {
//                static let expectedOutput = "00b606d89f07ee6f01e9602f57766d67df722b6d6597e03bed0270adb80eca1d7c68e4209b1831613505927d17b21194093a9abe3bbe1b5b8680d7d6a3dd884d1a59ca5a7b370fdc6e2d83da99310c700440a1e287ee76adac8f115b5176915f8afaac2013a45234c72f125988011d1344adc80ff95653b631696daf06c0aa4dad1b9cf4bf6a2edc89337c40360aa51c2ec1532da52e8e4d2bf9a1f45985d725f37875c97d7410cc36b3db6bc46c465724b34c75839485b14b4215613bc57c6d2510129c0c9cde00d5752fbcc7920cd07b9e94648ace4705f3e4852336081134d46ec27a87fe896a3310d262f76fdf4500f0b3b1fb94d7dcf8d8d83bd1c7b06a"
//            }
//        }
//
//        do {
//            let result = try PLLoginUserKeyReEncryptionUseCase.decryptSoftTokenUserKeyUsingTrustedDevicePrivateKey(privateKey: Constants.Input.privateKey,
//                                                                                                                   encodedSoftwareTokenKey: Constants.Input.encodedSoftwareTokenKey)
//            XCTAssertEqual(result.toHexString(), Constants.Output.expectedOutput)
//        } catch {
//            XCTFail("testDecryptSoftTokenUserKeyUsingTrustedDevicePrivateKey Error")
//        }
//    }
//
//    func testReEncryptUserKey() {
//        enum Constants {
//            enum Input {
//                static let appId = "OneAppd1dd7c5a1ddce9fbae"
//                static let pin = "1357"
//                static let encodedAndEncryptedUserKey =
//                    "iZsPNKxeU/U60oROtFiwlqJSYpbiOxNIXzvJacvJjkoin6sffTgeaYNfzK4qnMl0rdS5NSPfzy06ONmNBIvy1NSmtgVYOVEz+uXKVkpcaeJjG27JADhV2jEJCj3h0k28IybNd5sjBrteCLnxuEVvtqWBJwPr/xaxQkkNsxEG1B/ok2gKA5sXbNXgAYbe8ViA0mIm9tZ4CYdflg1h5nN7l9Vpe9oftgFPgc26/+220NFvSCfIpc1/RfRqyRTEncntupAW4UoSyKlfvYpiW3ewmTRiRRQcrxfBhaD45pysKSDooiblA3kwXmqB3STlbRe4l0D8oCnRKviKf/1JNV1hAA=="
//                static let privateKeyLength = 2048
//                static let privateKey: SecKey = {
//                    let privateKeyBase64 = "MIIEowIBAAKCAQEA0VYHiw9o7YB5guzcqzlHkNiJxCoNlOkPW8qs/ghO7dKPuB36cY1BPlzkf5apEkIAgCuHT1JdINn+a8KSRpKwFgIyfwmf2WwOW/acOQAOjzdSmZLNgWSyh043cB5kMm78P7RpuV3NYfs74V+DJ3lyr7L2qnpsU8lDV0Yy4XXOz1Diks7oPYXag3NI9p27Iuic9IBs1j0ia1I4hONtZVszX3/dW3mwloiDQUXUfGwEkfJ7tz6oeXkHyIKiZZPImZn4LamtI17KBa/i3/cMTMClh1jGC/1KEmmrhl9AiCV+PL5L6R0QhIbKqLFJGQYVn04xJWn+Yuik+Nn9DPy3aZ7vkQIDAQABAoIBAAj8NVSts6ZGFnEdM5eR3NWFxdwKpgyXOFaLS4OX3bNtj0eq2b4X/w3rNM+ZKuaiuJzHwYYRFfg8AySi9F5dG3vGWl6Djj3p2m/uFOSJcRaKnFwFJhcAuH0ASXbhhxF3HBKr7sHLGe6ztu1EiT+fgeGyv82vdYjfIanUVIjC4r6ZOVCZPzsopbGzgJGI29/+6n8G2ySU9BA0z8YqVFAHpj9FNjN4gyh+fppD2DygdAVS78PvEpOrvbMJFbtiGXj6h8H6Q7Oo8W6/FcrvlEVWOlEjnoNiPTi0bArvPdY0dh/Aj3rS/vt3623YzRmvrSC3XEgJYVGpSCoSis1tHArLJTECgYEA6kWoIzl9oqmOyszJf0E6MoEDnSxfIhGu7qJFGKGCAQC4e/LIKgNnOl+ti7WiVP8JnBtYqGdO/061RmUDM96rk+ngmXDsHPew5iDIzLkFVecBNY5o9Ld4XrSgHiw+9DyNWzCxEKC9Njq0Fe9p5QrP9i8+Yhnpwdq+9dEsIaunc00CgYEA5MBQX/ZNH4VUfyk+fd/KCXGip31yjjbLPfctKsdPY24GrYTXJRtOgYJFVQT5Ic6Fwn+ziVTXut4zlJC70mzZB3vAjTJvTOO43RMlOE3ieaNCkts/R1htRfYfh8pDhG4Qbhd62eXjtTaLoQ2xDA0IGsziaMWehxQH1l3Entn6w1UCgYAhmSHXA2zAQl8HOL2BMaKeEaCqDu4J3c1fzgfo02joqejLZfNNCzXnykcCbWc9l2IScF2TsVVECk63LM97xeiHixg6CVbjhKZrKrKBodthCYND4gutZQ6vTmpUSXYx4ulG9cG/J75bI6omJzLhtV5D6VyiByNeOPgAGyKgJZUbVQKBgQDRt874a6NBZseU3YdBd86O4fOxgr1nzKyA3wA13AzYp6LPqp5kkqhi68AMtkaBzAmty84Z9gLie5zmc9r+jHRc/AQIb1jDMXPmmwrgl+cuhZMfeIqHKnbkUUWPBMzpuM6vYC9tXepp1Nwmh5rt5XSsvXJFhAhW5vJYghclW8sfEQKBgC9NCTyOb5twCTQFbzEVh3Bw9I5KZGQAOByp6XzHrxQk78KUQ9O0l1bu1lxI+x7yITYvgExAG/gfc8f0oZr1Pj1RO6DZhCufTgR6XUbZ4zGWnSFo8jZvcgAe93ZwqipjlyZycSth6NqTofOobOsEZAYqEZ4KCNEv5N9dojHNBP6W"
//                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
//                }()
//            }
//            enum Output {
//                static let expectedOutput: [UInt8] = [247, 51, 221, 61, 119, 225, 185, 130, 111, 252, 199, 122, 84, 41, 159, 95, 239, 198, 46, 151, 129, 93, 78, 220, 62, 9, 188, 54, 114, 64, 103, 99]
//            }
//        }
//
//        do {
//            let result = try PLLoginUserKeyReEncryptionUseCase.reEncryptUserKey(Constants.Input.appId,
//                                                                                pin: Constants.Input.pin,
//                                                                                privateKey: Constants.Input.privateKey,
//                                                                                privateKeyLength: Constants.Input.privateKeyLength,
//                                                                                encryptedUserKey: Constants.Input.encodedAndEncryptedUserKey)
//            print(result)
//            XCTAssertEqual(result, Constants.Output.expectedOutput)
//        } catch {
//            XCTFail("testDecryptSoftTokenUserKeyUsingTrustedDevicePrivateKey Error")
//        }
//    }
//}

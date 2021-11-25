//
//  PLTrustedDeviceUserKeyEncryptionUseCaseTest.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 6/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Commons
import CoreFoundationLib
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

    func testReencryptionForPoland() throws {
        enum Constants {
            enum Input {
                static let tokens: [TrustedDeviceSoftwareToken] =
                    [TrustedDeviceSoftwareToken(name: "14039365223050490460",
                                                key: "CCl/0C6wODPv8DqrQwYHYTRUw3zTB4ZVNIJSlOssyKxV/594qiMdwh/g12ar+J/YRdOWrZSpuG+joQJZf+kcC0fTfOzdNCjN/QwZ+FrqsSJQrw7ZADSvM8PuastJmkPawxf2heo52s9e4xciw9DWRXutlUld6kJ5CcHwZzF9NKvfzBzaJ7Jl7p4PKAzWgYGsOcYp9+Nzy20TSAhopMzvst2PKFgNsewiyXpjkTo1yLygsxvF7J1N6MtTEpO75Pwv98V+4UZIiBaszTtFUiXSrlP6Ak/yew60jfEagW0WlwmEiPqsUIkk/S5Z7MV6oWMsGNOMri+kc82TT8layie/Mg==",
                                                type: "PIN",
                                                state: "PENDING",
                                                id: 158621,
                                                timestamp: 56223121),
                     TrustedDeviceSoftwareToken(name: "17498129736871031388",
                                                key: "ZxoqaQNuC21npmzMZHP2k0yq1XLaSz7oaGdPjoRhxIPbs0MWJFo/2QyYCRU3r95jIfkmHNvK93I/xTijCMhtESHGZYocLrRonak3A6fu9jm6GyyIw6WDGDi2e0FYxmB9PzpBZYor/s8hrVbB9l9AZnn66DqF/Q3jqzrvHb6OSKw6LEjkbAuHxmEYoFa3jrKpiByIiSLgXENnvforTzfwT+9P0DQ/DFfQPr5Rwv8OyQxo3Djl1p5I+CJaDEIkzZmhCgfROQ2XFh9Y1D9jW+lfbkZtDgVlEco41OItiiaPmOLA9YVk5fHB8LPT4djeRQbP0f6/c/HUt0l3wMGmY2YdEw==",
                                                type: "BIOMETRICS",
                                                state: "PENDING",
                                                id: 158622,
                                                timestamp: 56221837)]
                static let appId = "OneApp74a48dacd3a7484424"
                static let pin = "1357"
                static let privateKey: SecKey = {
                    let privateKeyBase64 =
                    "MIIEogIBAAKCAQEAp6IBXZJiNERUrb7GFf+wEsrVVTTr9ljfQ1gn9lhnRiSprbjPlv0k+2GO5fKv/GSSK9Fl+YG2QsDdmvpH4U6h2aulf5LYQgc0Ekqc+Ao597YldYswSr2/gvZ7CGfPM7SA5Cv95aE/4o+8u3Uv1wNGXjfmY2E+zp/gDY22HtDovOdkJeocEt0XQBD4XYJNy1YzFAAhDeyiFo5HV5buE+eqDtR4A71isEgb0WfJy4xk3X/CXCXfk+67Y2uV79VmIV/KsxF2rvbk6zAm/+/HoFcBkfL0Po3P/X8ndjmsRi0tyigdZustP7lZXFueLDTC0EwcsVGJnPVPPXMkNtXWQenlKQIDAQABAoIBAD29C/WzeRm45NsMvRXTEr0JGSMFl7YmKyw5ZpZzHq4VyKxjuYjpeNpgpumHxUsWm0MqHv2SyVayg6uVbC3N8QwjDJP8uEsxLftioYc09P6HhipRdhrA4azRLKT+3rAzVZkznpIZHldKCv+bfGAbI6qFugN2CFS/SxySybV1yZHwqekOzCRHjU/Vz1quDFrtlYZn9U1afjWwnobxtRDaiCRLO6OiaWiQgFIO8I4fktTADgEmaSmukjmqsyXepkOKeu0A14TRKOz54izC+YB5vl4w9NRwYQEuO4mtLAKUdTNHBGpUN6fgExVjnAAVY26JplZbQoD0OG5UOKowvIqLOXUCgYEA3Nrsdy2dwXbMNd1h11fOPC/evEm1AP32X1JCBnbRxB5+x1uUYswIEHFAA30LfEeBcwYaajbD9NA+/tNKXjjq+0Q8B3ZO16QAzOuOArBn/Aty6FnRkZq4dB+ObDIeCbgzq6fYVF1FW7ID+TWlJIJ2lZW6VAYBR51Ymes70xjhHQ8CgYEAwk7wetSvEy+uFlDEJYmU9nTV0/1VXOWRsw74Wwi7OfvLxMyfm36J1RvWrHgvKunFupVDceJXJF94Wg59++OniM/vbK3xP1kfN+ZcQFWvrEEciiJNOYW10Y5trKqeY7hk+oI4NnYgAF1zg12+baePn8cNs9JMJDFF+6N6zSajykcCgYBNmywekMvvcIQ/pUQ9PGB+679T4H6XE6agRjJnPRdm1+RqvzZ8JP/sby80Sptfl2zYc1uS2R2wiACq4KowQ8Xmd0q0wJDh24Jgf6FONpjDi25cUTt/86M/Qtt0D4RYm/6kIf21X3UAzKPyzTPziViMJans3pNSi+rXYz6JZiOsZwKBgDFdcMckBZ6wPGA7ALowrAG5SSHkeK1zPYLqSLqIC1j92ZUUD3Cnw0i7G90RY5pZbfyrM0lZoZ4CC0eF6wf1nHirqz5HKsVXVREUm1dU7Z6rpB6L/Gaiy8CDmOWHK1pWXIEwWCut8w9krpYvWNPvABQttBN9WA7R3d/Cds5sBKy9AoGAd2tiDBPIylE1+yjY+gGm8PlFtO0m3r6YznaQVOjwfJXT1OEbyrJ1ZdXVHw9lHgWjGJu5Td7i/DRzpYxiTx0mMSzMp8Uq3jSgUInijy7XvWID/mhvuD8vgx+ObPdNShQFpfZiCxcp6IkR13nm9czz+AM586+iXLPexQpPO4aOj7Q="
                    return SecKey.secKey(with: privateKeyBase64, isPrivate: true)!
                }()
            }
            enum Output {
                enum EncryptedKeys {
                    static let PIN = "TUCES38EOm6lI7EQunUETkltokeZvHNoEjE2lOmXLbw="
                    static let BIOMETRICS = "R6Ztut7X3lUVzdpmrnPEGDHOyHV9yAftm5mO/MRDhgQ="
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

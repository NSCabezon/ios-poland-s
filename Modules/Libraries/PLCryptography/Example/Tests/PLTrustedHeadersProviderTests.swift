//
//  PLTrustedHeadersProviderTests.swift
//  SANPLLibrary_Tests
//
//  Created by 187830 on 01/11/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import SANLegacyLibrary
import Commons
import CoreFoundationLib
import SANPLLibrary

@testable import PLCryptography

class PLTrustedHeadersProviderTests: Tests {
    
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var sut: PLTrustedHeadersGenerable!
    private var secIdentity: SecIdentity!
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        secIdentity = SecIdentity.create(
            ofSize: 2048,
            subjectCommonName: "Santander",
            subjectOrganizationName: "Santander",
            contryName: "PL"
        )!
        setUpDependencies()
        sut = dependencies.resolve(for: PLTrustedHeadersGenerable.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        sut = nil
        _ = try? SecIdentity.deleteSecIdentity(
            label: PLConstants.certificateIdentityLabel
        )
        secIdentity = nil
    }
    
    
    // PRAGMA MARK: Test separate and encrypt parameters string
    func testDeviceParametersSeparation() {
        enum Input {
            static let parameters = "<2021-04-18 22:01:11.238><<AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>>"
        }
        enum Output {
            static let result = "PDIwMjEtMDQtMTggMjI6MDE6MTEuMjM4Pjw8QXBwSWQ+PDEyMzQ1Njc4OTBhYmNkZWYxMjM0NTY3OD5MSGwer2CoMmP72bsKJR4jiiLL0iN3tXvHVmT/o8l75Q=="
        }
        
        let encryptedParameters = PLTrustedHeadersProvider.separateAndParciallyHashParameters(parameters: Input.parameters)
        XCTAssertEqual(encryptedParameters?.toBase64(), Output.result)
    }
    
    func testNotShouldGenerateDeviceIdForTrustedDeviceTrue() {
        _ = try? SecIdentity.updateSecIdentity(
            secIdentity: secIdentity, label: PLConstants.certificateIdentityLabel
        )
        let deviceDataFirst  = sut.generateDeviceData(
            transactionParameters: nil,
            isTrustedDevice: true
        )
        let deviceDataSecond  = sut.generateDeviceData(
            transactionParameters: nil,
            isTrustedDevice: true
        )
        XCTAssert(deviceDataFirst.deviceId == deviceDataSecond.deviceId)
    }
    
    func testShouldGenerateNewDeviceIdForTrustedDeviceFalse() {
        _ = try? SecIdentity.updateSecIdentity(
            secIdentity: secIdentity, label: PLConstants.certificateIdentityLabel
        )
        let deviceDataFirst  = sut.generateDeviceData(
            transactionParameters: nil,
            isTrustedDevice: false
        )
        let deviceDataSecond  = sut.generateDeviceData(
            transactionParameters: nil,
            isTrustedDevice: false
        )
        XCTAssert(deviceDataFirst.deviceId != deviceDataSecond.deviceId)
    }
    
    func testShouldGenerateNewParametersForTransactionParameters() {
        _ = try? SecIdentity.updateSecIdentity(
            secIdentity: secIdentity, label: PLConstants.certificateIdentityLabel
        )
        let deviceDataFirst  = sut.generateDeviceData(
            transactionParameters: TransactionParameters(
                joinedParameters: ""
            ),
            isTrustedDevice: true
        )
        let deviceDataSecond  = sut.generateDeviceData(
            transactionParameters: TransactionParameters(
                joinedParameters: ""
            ),
            isTrustedDevice: true
        )
        XCTAssert(deviceDataFirst.parameters != deviceDataSecond.parameters)
        XCTAssert(deviceDataFirst.deviceId == deviceDataSecond.deviceId)
    }
}

private extension PLTrustedHeadersProviderTests {
    func setUpDependencies() {
        dependencies.register(for: PLTrustedHeadersGenerable.self) { resolver in
            PLTrustedHeadersProvider(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: DataSourceProvider.self) { _ in
            return DataSourceProviderImpl(
                defaultDataSource: MemoryDataSource(),
                dataSources: [MemoryDataSource()]
            )
        }
        
        let trustedHeadersProvider = dependencies.resolve(for: PLTrustedHeadersGenerable.self)
        
        let bsanDataProvier = BSanDataProviderMockBuilder.bsanDataProvider
        let demoInterpreter = DemoUserInterpreter(
            bsanDataProvider: bsanDataProvier,
            defaultDemoUser: "12345678Z",
            demoModeAvailable: true
        )
        let networkProvider = PLNetworkProvider(
            dataProvider: bsanDataProvier,
            demoInterpreter: demoInterpreter,
            isTrustInvalidCertificateEnabled: false,
            trustedHeadersProvider: trustedHeadersProvider
        )
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProvider(
                bsanDataProvider: bsanDataProvier,
                hostProvider: PLHostProviderMock(),
                networkProvider: networkProvider,
                demoInterpreter: demoInterpreter
            )
        }
    }
}


//
//  PLLoginServiceUseCaseTest.swift
//  PLLogin_ExampleTests
//
//  Created by Mario Rosales Maillo on 29/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import CoreFoundationLib
import SANPLLibrary
import RetailLegacy
import PLLegacyAdapter
import PLCryptography
@testable import PLLogin

public class PLLoginServiceUseCaseTest: XCTestCase {
    
    private var testInterpreter: DemoUserInterpreter!
    internal var dependencies: DependenciesDefault!
    internal var managerProvider: PLManagersProviderProtocol!
    internal var useLocalFiles: Bool = false
    
    private enum Config {
        static let testUserId = "12345678z"
    }
    
    private lazy var dataRepository: DataRepository = {
        return DataRepositoryBuilder(dependenciesResolver: dependencies).build()
    }()
    
    private var bsanDataProvider: SANPLLibrary.BSANDataProvider {
        return SANPLLibrary.BSANDataProvider(dataRepository: dataRepository)
    }
    
    private var managersProviderAdapter: PLManagersProviderAdapter!
    
    public override func setUpWithError() throws {
        try super.setUpWithError()
        self.dependencies = DependenciesDefault()
        self.setServiceDependencies()
        self.managerProvider = self.dependencies.resolve(for: PLManagersProviderProtocol.self)
        guard self.useLocalFiles else { return }
        _ = self.managerProvider.getLoginManager().setDemoModeIfNeeded(for: Config.testUserId)
    }
    
    public override func tearDownWithError() throws {
        try super.tearDownWithError()
        testInterpreter.setTestFile(nil, bundle: nil)
    }
    
    public func setTestFile(_ file: String) {
        testInterpreter.setTestFile(file, bundle: Bundle(for: PLLoginServiceUseCaseTest.self))
    }
    
    private func setServiceDependencies() {
        
        self.dependencies.register(for: VersionInfoDTO.self) { _ in
            return VersionInfoDTO(bundleIdentifier: Bundle.main.bundleIdentifier ?? "",
                                  versionName: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "")
        }
        
        self.dependencies.register(for: CompilationProtocol.self) { _ in
            return Compilation()
        }
        
        self.dependencies.register(for: PLTrustedHeadersGenerable.self) { resolver in
            PLTrustedHeadersProvider(dependenciesResolver: resolver)
        }
        
        self.testInterpreter = DemoUserInterpreter(bsanDataProvider: bsanDataProvider,
                                                   defaultDemoUser: Config.testUserId,
                                                   demoModeAvailable: true)
        
        let trustedHeaderProvider = self.dependencies.resolve(for: PLTrustedHeadersGenerable.self)
        let networkProvider = PLNetworkProvider(dataProvider: bsanDataProvider,
                                                demoInterpreter: testInterpreter,
                                                isTrustInvalidCertificateEnabled:true,
                                                trustedHeadersProvider: trustedHeaderProvider)
        self.managersProviderAdapter = PLManagersProviderAdapter(bsanDataProvider: self.bsanDataProvider,
                                                                 hostProvider: PLHostProvider(),
                                                                 networkProvider: networkProvider,
                                                                 demoInterpreter: self.testInterpreter)
        self.dependencies.register(for: PLManagersProviderProtocol.self) { _ in
            return self.managersProviderAdapter.getPLManagerProvider()
        }
    }
}

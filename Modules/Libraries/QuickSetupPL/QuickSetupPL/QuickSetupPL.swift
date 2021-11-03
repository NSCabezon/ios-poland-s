//
//  QuickSetup.swift
//  QuickSetup
//
//  Created by Jose Carlos Estela Anguita on 26/09/2019.
//  Copyright © 2019 Jose Carlos Estela Anguita. All rights reserved.
//

import SANLegacyLibrary
import DataRepository
import QuickSetup
import Foundation
import Commons
import Models
import CoreTestData
import SANPLLibrary
import PLLegacyAdapter

public class QuickSetupForPLLibrary {
    private var mockDataInjector = MockDataInjector()
    private let hostProvider = PLHostProvider()
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let user: User
    
    private lazy var versionInfo: VersionInfoDTO = {
        return VersionInfoDTO(
            bundleIdentifier: Bundle.main.bundleIdentifier ?? "",
            versionName: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
    }()
    
    private lazy var dataRepository: DataRepository = {
        return DataRepositoryBuilder(appInfo: versionInfo).build()
    }()
    
    private var bsanDataProvider: SANPLLibrary.BSANDataProvider {
        return SANPLLibrary.BSANDataProvider(dataRepository: dataRepository)
    }
    
    private var demoInterpreter: DemoUserProtocol {
        return DemoUserInterpreter(bsanDataProvider: bsanDataProvider, defaultDemoUser: "12345678Z",
                                   demoModeAvailable: true)
    }
    private var plManagersProvider: PLManagersProvider {
        let networkProvider = PLNetworkProvider(dataProvider: bsanDataProvider, demoInterpreter: demoInterpreter, isTrustInvalidCertificateEnabled: false)
        return PLManagersProvider(bsanDataProvider: bsanDataProvider, hostProvider: hostProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
    }
    
    private lazy var managersProviderAdapter: PLManagersProviderAdapter = {
        let networkProvider = PLNetworkProvider(dataProvider: bsanDataProvider, demoInterpreter: demoInterpreter, isTrustInvalidCertificateEnabled: false)
        return PLManagersProviderAdapter(bsanDataProvider: self.bsanDataProvider,
                                         hostProvider: hostProvider,
                                         networkProvider: networkProvider,
                                         demoInterpreter: self.demoInterpreter)
        
    }()
    
    public init(environment: BSANPLEnvironmentDTO, user: User, dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
        self.user = user
        BSANLogger.setBSANLogger(self)
        self.setEnviroment(environment)
    }
}

private extension QuickSetupForPLLibrary {
    func setEnviroment(_ environment: BSANPLEnvironmentDTO) {
        let _ = plManagersProvider.getEnvironmentsManager().setEnvironment(bsanEnvironment: environment)
    }
    
    func isDemo(_ username: String?) -> Bool {
        if let username = username {
            return self.demoInterpreter.isDemoUser(userName: username)
        }
        return false
    }
    
    func getGlobalPosition() -> GlobalPositionRepresentable? {
        let response = try? self.managersProviderAdapter.getBsanPGManager().getGlobalPosition()
        _ = try? self.managersProviderAdapter.getBsanCardsManager().loadCardSuperSpeed(pagination: nil)
        let globalPosition = try? response?.getResponseData()
        let cardsData = try? self.managersProviderAdapter.getBsanCardsManager().getCardsDataMap().getResponseData()
        let temporallyInactiveCards = try? self.managersProviderAdapter.getBsanCardsManager().getTemporallyInactiveCardsMap().getResponseData()
        let inactiveCards = try? self.managersProviderAdapter.getBsanCardsManager().getInactiveCardsMap().getResponseData()
        _ = try? self.managersProviderAdapter.getBsanSignatureManager().loadCMCSignature()
        _ = try? self.managersProviderAdapter.getBsanSendMoneyManager().loadCMPSStatus()
        let cardBalances = try? self.managersProviderAdapter.getBsanCardsManager().getCardsBalancesMap().getResponseData()
        return globalPosition.map {
            GlobalPositionMock($0, cardsData: cardsData ?? [:], temporallyOffCards: temporallyInactiveCards ?? [:], inactiveCards: inactiveCards ?? [:], cardBalances: cardBalances ?? [:])
        }
    }
    
    func getGlobalPositionMock() -> GlobalPositionMock? {
        let response = try? self.managersProviderAdapter.getBsanPGManager().getGlobalPosition()
        guard let globalPosition = try? response?.getResponseData() else { return nil }
        _ = try? self.managersProviderAdapter.getBsanCardsManager().loadCardSuperSpeed(pagination: nil)
        let cardsData = try? self.managersProviderAdapter.getBsanCardsManager().getCardsDataMap().getResponseData()
        let temporallyInactiveCards = try? self.managersProviderAdapter.getBsanCardsManager().getTemporallyInactiveCardsMap().getResponseData()
        let inactiveCards = try? self.managersProviderAdapter.getBsanCardsManager().getInactiveCardsMap().getResponseData()
        _ = try? self.managersProviderAdapter.getBsanSignatureManager().loadCMCSignature()
        _ = try? self.managersProviderAdapter.getBsanSendMoneyManager().loadCMPSStatus()
        let cardBalances = try? self.managersProviderAdapter.getBsanCardsManager().getCardsBalancesMap().getResponseData()
        return GlobalPositionMock(globalPosition, cardsData: cardsData ?? [:], temporallyOffCards: temporallyInactiveCards ?? [:], inactiveCards: inactiveCards ?? [:], cardBalances: cardBalances ?? [:])
    }
    
    func doLogin(withUser user: User) {
        do {
            _  = self.plManagersProvider.getLoginManager().setDemoModeIfNeeded(for: user.user)
            _ = try self.managersProviderAdapter.getBsanPGManager().loadGlobalPosition(onlyVisibleProducts: true, isPB: user.isPB)
        } catch {
            debugPrint("Something going wrong when try to login with user: \(user)")
        }
    }
}

extension QuickSetupForPLLibrary: ServicesProvider {
    
    public func registerDependencies(in dependencies: DependenciesInjector & DependenciesResolver) {
        dependencies.register(for: BSANDataProviderProtocol.self) { _ in
            return self.bsanDataProvider
        }
        for serviceInjector in dependencies.resolve(for: [CustomServiceInjector].self) {
            serviceInjector.inject(injector: self.mockDataInjector)
        }
        dependencies.register(for: BSANManagersProvider.self) { _ in
            return self.managersProviderAdapter
        }
        dependencies.register(for: GlobalPositionRepresentable.self) { _ in
            return self.getGlobalPosition()!
        }
        dependencies.register(for: GlobalPositionWithUserPrefsRepresentable.self) { resolver in
            let globalPosition = resolver.resolve(for: GlobalPositionRepresentable.self)
            return GlobalPositionPrefsMergerEntity(resolver: resolver, globalPosition: globalPosition, saveUserPreferences: true)
        }
        MockRepositoryManager(dependencies: dependencies, mockDataInjector: mockDataInjector).registerDependencies()
        FakeLoginTokenInjector.injectToken(dependenciesEngine: dependencies)
        doLogin(withUser: self.user)
    }
}

extension QuickSetupForPLLibrary: BSANLog {
    public func v(_ tag: String, _ message: String) {
        print(message)
    }
    
    public func v(_ tag: String, _ object: AnyObject) {
        print(object)
    }
    
    public func i(_ tag: String, _ message: String) {
        print(message)
    }
    
    public func i(_ tag: String, _ object: AnyObject) {
        print(object)
    }
    
    public func d(_ tag: String, _ message: String) {
        print(message)
    }
    
    public func d(_ tag: String, _ object: AnyObject) {
        print(object)
    }
    
    public func e(_ tag: String, _ message: String) {
        print(message)
    }
    
    public func e(_ tag: String, _ object: AnyObject) {
        print(object)
    }
}

//
//  ViewController.swift
//  PLHelpCenter
//
//  Created by piotr-papierok-san on 08/02/2021.
//  Copyright (c) 2021 piotr-papierok-san. All rights reserved.
//

import UIKit
import UI
import PLHelpCenter
import Commons
import PLCommons
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary

class ViewController: UIViewController {

    @IBOutlet weak var languageTextField: UITextField!
    
    private let sideMenuCoordinatorNavigator = SideMenuCoordinatorNavigator()
    private lazy var coordinator = PLHelpCenterModuleCoordinator(
        dependenciesResolver: dependenciesResolver,
        navigationController: navigationController
    )
    
    private var mockData: PLHelpCenterMockData = PLHelpCenterMockData()
    private var clientProfileProvider: HelpCenterClientProfileProvider = { .notLogged }
    private var currentLanguageProvider: CurrentLanguageProvider = { Locale.current.identifier }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        UIStyle.setup()
        
        languageTextField.text = Locale.preferredLanguages.first?.substring(0, 2)
        currentLanguageProvider = { [weak self] in
            DispatchQueue.main.sync {
                self?.languageTextField.text ?? "en"
            }
        }
    }

    private func setupNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("Module Menu")))
            .setRightActions(.close(action: #selector(didSelectClose)))
            .build(on: self, with: nil)
    }
    
    @objc func didSelectClose() {} // Just to fix bug, it seems that at least one image must be loaded before calling UIStyle.setup()
    
    @IBAction func userNotLoggedTap(_ sender: Any) {
        clientProfileProvider = { .notLogged }
        coordinator.start()
    }
    
    @IBAction func individualUserLoggedTap(_ sender: Any) {
        clientProfileProvider = { .individual }
        coordinator.start()
    }
    
    internal lazy var dependenciesResolver: DependenciesResolver = {
        let defaultResolver = DependenciesDefault()
        
        defaultResolver.register(for: PLHelpCenterModuleCoordinatorDelegate.self) { [unowned self] _ in
            return self.sideMenuCoordinatorNavigator
        }
        
        defaultResolver.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
        defaultResolver.register(for: UseCaseScheduler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
        defaultResolver.register(for: PLWebViewLinkRepositoryProtocol.self) { _ in
            return FakePLWebViewLinkRepository()
        }
        
        defaultResolver.register(for: AppConfigRepositoryProtocol.self) { _ in
            return FakeAppConfigRepository()
        }
        
        defaultResolver.register(for: PLManagersProviderProtocol.self) { [unowned self]_ in
            return FakePLManagersProvider(mockData: self.mockData, clientProfileProvider: clientProfileProvider)
        }
        
        defaultResolver.register(for: BSANDataProviderProtocol.self) { [unowned self] _ in
            return FakeBSANDataProvider()
        }
        
        defaultResolver.register(for: StringLoader.self) { [unowned self] _ in
            return FakeStringLoader(currentLanguageProvider: currentLanguageProvider)
        }
        
        return defaultResolver
    }()
}

final class SideMenuCoordinatorNavigator: PLHelpCenterModuleCoordinatorDelegate {
    func didSelectMenu() {
        Toast.show("Side Menu is Not available in example App")
    }
}

struct FakePLWebViewLinkRepository: PLWebViewLinkRepositoryProtocol {
    func getWebViewLink(forIdentifier identifier: String) -> PLWebViewLink? {
        return getWebViewLink(forIdentifier: identifier, fromGroups: [])
    }
    func getWebViewLink(forIdentifier identifier: String, fromGroups groups: [PLWebViewLinkRepositoryGroup]) -> PLWebViewLink? {
        return PLWebViewLink(id: "", url: "", method: .get, isAvailable: false)
    }
}

final class FakeAppConfigRepository: AppConfigRepositoryProtocol {
    func getBool(_ nodeName: String) -> Bool? {
        nil
    }
    
    func getDecimal(_ nodeName: String) -> Decimal? {
        nil
    }
    
    func getInt(_ nodeName: String) -> Int? {
        nil
    }
    
    func getString(_ nodeName: String) -> String? {
        nil
    }
    
    func getAppConfigListNode(_ nodeName: String) -> [String]? {
        nil
    }
    
    func getAppConfigListNode<T>(_ nodeName: String, object: T.Type, options: AppConfigDecodeOptions) -> [T]? where T : Decodable {
        nil
    }
}

final class FakePLManagersProvider: PLManagersProviderProtocol {

    init(mockData: PLHelpCenterMockData, clientProfileProvider: @escaping HelpCenterClientProfileProvider) {
        self.mockData = mockData
        self.clientProfileProvider = clientProfileProvider
    }
    
    private let clientProfileProvider: HelpCenterClientProfileProvider
    private let mockData: PLHelpCenterMockData
    
    func getLoginManager() -> PLLoginManagerProtocol {
        FakePLLoginManager(clientProfileProvider: clientProfileProvider)
    }
    
    func getHelpCenterManager() -> PLHelpCenterManagerProtocol {
        FakePLHelpCenterManager(mockData: mockData)
    }
    
    func getCardOperativesManager() -> PLCardOperativesManagerProtocol {
        fatalError()
    }
}

final class FakePLHelpCenterManager: PLHelpCenterManagerProtocol {
    
    init(mockData: PLHelpCenterMockData) {
        self.mockData = mockData
    }
    
    private let mockData: PLHelpCenterMockData
    
    func getOnlineAdvisorConfig() throws -> Result<OnlineAdvisorDTO, NetworkProviderError> {
        guard !mockData.forceOnlineAdvisorError else { return .failure(.other) }
        if let onlineAdvisorDTO = mockData.onlineAdvisorDTO {
            return .success(onlineAdvisorDTO)
        } else {
            return .failure(.other)
        }
    }
    
    func getHelpQuestionsConfig() throws -> Result<HelpQuestionsDTO, NetworkProviderError> {
        guard !mockData.forceHelpQuestionsError else { return .failure(.other) }
        if let helpQuestionsDTO = mockData.helpQuestionsDTO {
            return .success(helpQuestionsDTO)
        } else {
            return .failure(.other)
        }
    }
    
    func getUserContextForOnlineAdvisor(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError> {
        guard !mockData.forceOnlineAdvisorUserContextError else { return .failure(.other) }
        if let onlineAdvisorUserContextDTO = mockData.onlineAdvisorUserContextDTO {
            return .success(onlineAdvisorUserContextDTO)
        } else {
            return .failure(.other)
        }
    }
    
    func getUserContextForOnlineAdvisorBeforeLogin(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError> {
        guard !mockData.forceOnlineAdvisorUserContextError else { return .failure(.other) }
        if let onlineAdvisorUserContextDTO = mockData.onlineAdvisorUserContextDTO {
            return .success(onlineAdvisorUserContextDTO)
        } else {
            return .failure(.other)
        }
    }
}

final class FakeBSANDataProvider: BSANDataProviderProtocol {
    
    func getAuthCredentialsProvider() throws -> AuthCredentialsProvider {
        return SANPLLibrary.AuthCredentials(login: nil, userId: nil, userCif: nil, companyContext: nil, accessTokenCredentials: nil, trustedDeviceTokenCredentials: nil)
    }
    
    public func getLanguageISO() throws -> String {
        return "pl"
    }
    
    public func getDialectISO() throws -> String {
        return "PL"
    }
    
    public func store(creditCardRepaymentAccounts accounts: [CCRAccountDTO]) {
        
    }
    
    public func store(creditCardRepaymentCards cards: [CCRCardDTO]) {
        
    }

    public func getCreditCardRepaymentInfo() -> CreditCardRepaymentInfo? {
        return nil
    }
    
    public func cleanCreditCardRepaymentInfo() {
        
    }
}

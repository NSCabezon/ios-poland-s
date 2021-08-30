//
//  AppDependencies.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import Commons
import Foundation
import DataRepository
import RetailLegacy
import Repository
import SANLegacyLibrary
import SANPLLibrary
import PLLegacyAdapter
import PLCommons
import Models
import GlobalPosition
import Account
import Inbox

final class AppDependencies {
    let dependencieEngine: DependenciesResolver & DependenciesInjector
    private let localAppConfig: LocalAppConfig
    private let versionInfo: VersionInfoDTO
    private let hostModule: HostsModuleProtocol
    private let compilation: PLCompilationProtocol
    private let appModifiers: AppModifiers
    private let ibanFormatter: ShareIbanFormatterProtocol
    
    // MARK: - Dependecies definitions
    
    // MARK: Data layer and country data adapters
    private lazy var dataRepository: DataRepository = {
        return DataRepositoryBuilder(dependenciesResolver: dependencieEngine).build()
    }()
    
    private var bsanDataProvider: SANPLLibrary.BSANDataProvider {
        return SANPLLibrary.BSANDataProvider(dataRepository: dataRepository)
    }
    private var demoInterpreter: DemoUserProtocol {
        let demoModeAvailable: Bool = XCConfig["DEMO_AVAILABLE"] ?? false
        return DemoUserInterpreter(bsanDataProvider: bsanDataProvider, defaultDemoUser: "12345678Z",
                                   demoModeAvailable: demoModeAvailable)
    }
    private lazy var managersProviderAdapter: PLManagersProviderAdapter = {

        let hostProvider = PLHostProvider()
        // TODO: Check value isTrustInvalidCertificateEnabled
        let networkProvider = PLNetworkProvider(dataProvider: bsanDataProvider, demoInterpreter: demoInterpreter, isTrustInvalidCertificateEnabled: false)
        return PLManagersProviderAdapter(bsanDataProvider: self.bsanDataProvider,
                                         hostProvider: hostProvider,
                                         networkProvider: networkProvider,
                                         demoInterpreter: self.demoInterpreter)

    }()
    private lazy var getPGFrequentOperativeOption: GetPGFrequentOperativeOptionProtocol = {
        return GetPGFrequentOperativeOption(dependenciesResolver: dependencieEngine)
    }()
    private lazy var productIdDelegate: ProductIdDelegateProtocol = {
        return ProductIdDelegateModifier()
    }()
    private lazy var accountDetailModifier: AccountDetailModifierProtocol = {
        return PLAccountDetailModifier()
    }()
    private lazy var notificationPermissionManager: NotificationPermissionsManager = {
        return NotificationPermissionsManager(dependencies: self.dependencieEngine)
    }()

    // MARK: Features
//    private lazy var onboardingPermissionOptions: OnboardingPermissionOptions = {
//        return OnboardingPermissionOptions(dependenciesResolver: dependencieEngine)
//    }()
//    private lazy var personalAreaSections: PersonalAreaSectionsProvider = {
//        return PersonalAreaSectionsProvider(dependenciesResolver: dependencieEngine)
//    }()
    
    // MARK: Dependencies init
    init() {
        self.dependencieEngine = DependenciesDefault()
        compilation = Compilation()
        versionInfo = VersionInfoDTO(
            bundleIdentifier: Bundle.main.bundleIdentifier ?? "",
            versionName: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        )
        hostModule = HostsModule()
        localAppConfig = PLAppConfig()
        appModifiers = AppModifiers(dependenciesEngine: dependencieEngine)
        self.ibanFormatter = ShareIbanFormatter()
        registerDependencies()
    }
}

private extension AppDependencies {
    // MARK: Dependencies registration
    func registerDependencies() {
        self.dependencieEngine.register(for: HostsModuleProtocol.self) { _ in
            return self.hostModule
        }
        self.dependencieEngine.register(for: DataRepository.self) { _ in
            return self.dataRepository
        }
        self.dependencieEngine.register(for: LocalAppConfig.self) { _ in
            return self.localAppConfig
        }
        self.dependencieEngine.register(for: VersionInfoDTO.self) { _ in
            return self.versionInfo
        }
        // Data layer and country data adapters
        self.dependencieEngine.register(for: BSANManagersProvider.self) { _ in
            return self.managersProviderAdapter
        }
        self.dependencieEngine.register(for: BSANDataProviderProtocol.self) { _ in
            return self.bsanDataProvider
        }
        dependencieEngine.register(for: PLManagersProviderProtocol.self) { _ in
            return self.managersProviderAdapter.getPLManagerProvider()
        }
        dependencieEngine.register(for: PLManagersProviderAdapter.self) { _ in
            return self.managersProviderAdapter
        }
        dependencieEngine.register(for: PLManagersProviderAdapterProtocol.self) { _ in
            return self.managersProviderAdapter
        }
        self.dependencieEngine.register(for: GetPGFrequentOperativeOptionProtocol.self) { _ in
            return self.getPGFrequentOperativeOption
        }
        // Legacy compatibility dependencies
        self.dependencieEngine.register(for: CompilationProtocol.self) { _ in
            return self.compilation
        }
        dependencieEngine.register(for: PLCompilationProtocol.self) { _ in
            return self.compilation
        }
        self.dependencieEngine.register(for: TrusteerRepositoryProtocol.self) { _ in
            return EmptyTrusteerRepository()
        }
        self.dependencieEngine.register(for: EmmaTrackEventListProtocol.self) { _ in
            return EmptyEmmaTrackEventList()
        }
        self.dependencieEngine.register(for: SiriAssistantProtocol.self) { _ in
            return EmptySiriAssistant()
        }
        self.dependencieEngine.register(for: TealiumCompilationProtocol.self) { _ in
            return EmptyTealiumCompilation()
        }
        self.dependencieEngine.register(for: SharedDependenciesDelegate.self) { _ in
            return self
        }
        self.dependencieEngine.register(for: ProductIdDelegateProtocol.self) { _ in
            return self.productIdDelegate
        }
        self.dependencieEngine.register(for: ShareIbanFormatterProtocol.self) { _ in
            return self.ibanFormatter
        }
        self.dependencieEngine.register(for: AccountDetailModifierProtocol.self) { _ in
            return self.accountDetailModifier
        }
        self.dependencieEngine.register(for: PushNotificationPermissionsManagerProtocol.self) { _ in
            return self.notificationPermissionManager
        }
        self.dependencieEngine.register(for: InboxActionBuilderProtocol.self) { resolver in
            return PLInboxActionBuilder(resolver: resolver)
        }
        self.dependencieEngine.register(for: GetFilteredAccountTransactionsUseCaseProtocol.self) { resolver in
            return PLGetFilteredAccountTransactionsUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: AccountTransactionProtocol.self) { _ in
            return PLAccountTransaction()
        }
    }
}

extension AppDependencies: SharedDependenciesDelegate {
    func publicFilesFinished(_ appConfigRepository: AppConfigRepositoryProtocol) {
    }
}

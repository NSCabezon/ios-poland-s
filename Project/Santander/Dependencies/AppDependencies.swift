//
//  AppDependencies.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import Commons
import Foundation
import DataRepository
import ESCommons
import RetailLegacy
import SANLibraryV3

final class AppDependencies {
    let dependencieEngine: DependenciesResolver & DependenciesInjector
    private let localAppConfig: LocalAppConfig
    private let versionInfo: VersionInfoDTO
    private let hostModule: HostsModuleProtocol
    private let compilation: CompilationProtocol
    
    // MARK: - Dependecies definitions
    
    // MARK: Data layer and country data adapters
    private lazy var dataRepository: DataRepository = {
        return DataRepositoryBuilder(dependenciesResolver: dependencieEngine).build()
    }()
//    private var bsanDataProvider: SANPLLibrary.BSANDataProvider {
//        return SANPLLibrary.BSANDataProvider(dataRepository: dataRepository, appInfo: versionInfo)
//    }
//    private lazy var managersProviderAdapater: PLManagersProviderAdapter = {
//        let hostProvider = PTHostProvider()
//        return PTManagersProviderAdapater(bsanDataProvider: bsanDataProvider, hostProvider: hostProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
//
//    }()
    private lazy var dataProvider: SANLibraryV3.BSANDataProvider = {
        return BSANDataProvider(dataRepository: dataRepository, appInfo: versionInfo)
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
        //appModifiers = AppModifiers(dependenciesEngine: dependencieEngine)
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
        self.dependencieEngine.register(for: BSANDataProvider.self) { _ in
            return BSANDataProvider(dataRepository: self.dataRepository, appInfo: self.versionInfo)
        }
        self.dependencieEngine.register(for: LocalAppConfig.self) { _ in
            return self.localAppConfig
        }
    }
}

extension AppDependencies: SharedDependenciesDelegate {
    func publicFilesFinished(_ appConfigRepository: AppConfigRepositoryProtocol) {
    }
}

//
//  AppDependencies.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import CoreFoundationLib
import Foundation
import RetailLegacy
import SANLegacyLibrary
import SANPLLibrary
import PLLegacyAdapter
import PLCommons
import PLCommonOperatives
import PLLogin
import GlobalPosition
import Account
import Inbox
import PersonalArea
import Menu
import Cards
import PLNotifications
import Loans
import CoreFoundationLib
import CoreDomain
import PLCryptography
import UI
import CorePushNotificationsService
import BLIK
import WebKit
import PLNotificationsInbox
import PLHelpCenter

final class AppDependencies {
    #if DEBUG
    private let timeToRefreshToken: TimeInterval = 10000000000000
    private let timeToExpireSession: TimeInterval = 10000000000000
    #else
    private let timeToRefreshToken: TimeInterval = 60 * 120
    private let timeToExpireSession: TimeInterval = 60 * 5
    #endif
    let dependencieEngine: DependenciesResolver & DependenciesInjector
    private let localAppConfig: LocalAppConfig
    private let versionInfo: VersionInfoDTO
    private let hostModule: HostsModuleProtocol
    private let compilation: PLCompilationProtocol
    private let appModifiers: AppModifiers
    private let ibanFormatter: ShareIbanFormatterProtocol
    private lazy var netClient = NetClientImplementation()

    // MARK: - Dependecies definitions

    // MARK: Data layer and country data adapters
    private lazy var defaultSessionDataManager: SessionDataManager = {
        return DefaultSessionDataManager(dependenciesResolver: dependencieEngine)
    }()
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
    private lazy var networkProvider: NetworkProvider = {
            return PLNetworkProvider(dataProvider: bsanDataProvider,
                                     demoInterpreter: demoInterpreter,
                                     isTrustInvalidCertificateEnabled: compilation.isTrustInvalidCertificateEnabled,
                                     trustedHeadersProvider: self.dependencieEngine.resolve(
                                         for: PLTrustedHeadersGenerable.self
                                     ))
        }()
    private lazy var managersProviderAdapter: PLManagersProviderAdapter = {
        let hostProvider = PLHostProvider()
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
    private lazy var accountTransactionsPDFModifier: AccountTransactionsPDFGeneratorProtocol = {
        return PLAccountTransactionsPDFGeneratorProtocol(dependenciesResolver: dependencieEngine)
    }()
    private lazy var notificationPermissionManager: NotificationPermissionsManager = {
        return NotificationPermissionsManager(dependencies: self.dependencieEngine)
    }()
    private lazy var notificationsHandler: NotificationsHandlerProtocol = {
        return NotificationsHandler(dependencies: self.dependencieEngine)
    }()
    private lazy var firebaseNotificationsService: FirebaseNotificationsService = {
        return FirebaseNotificationsService(dependenciesResolver: self.dependencieEngine)
    }()
    private lazy var plAccountOtherOperativesInfoRepository: PLAccountOtherOperativesInfoRepository = {
        let assetsClient = AssetsClient()
        let fileClient = FileClient()
        return PLAccountOtherOperativesInfoRepository(netClient: netClient, assetsClient: assetsClient, fileClient: fileClient)
    }()
    private lazy var plHelpCenterOnlineAdvisorRepository: PLHelpCenterOnlineAdvisorRepository = {
        let assetsClient = AssetsClient()
        let fileClient = FileClient()
        return PLHelpCenterOnlineAdvisorRepository(netClient: netClient, assetsClient: assetsClient, fileClient: fileClient)
    }()
    private lazy var plHelpQuestionsRepository: PLHelpQuestionsRepository = {
        let assetsClient = AssetsClient()
        let fileClient = FileClient()
        return PLHelpQuestionsRepository(netClient: netClient, assetsClient: assetsClient, fileClient: fileClient)
    }()
    private lazy var plTransferSettingsRepository: PLTransferSettingsRepository = {
        let assetsClient = AssetsClient()
        let fileClient = FileClient()
        return PLTransferSettingsRepository(netClient: netClient, assetsClient: assetsClient, fileClient: fileClient)
    }()
    private lazy var plTermsAndConditionsRepository: PLTermsAndConditionsRepository = {
        let assetsClient = AssetsClient()
        let fileClient = FileClient()
        return PLTermsAndConditionsRepository(netClient: netClient, assetsClient: assetsClient, fileClient: fileClient)
    }()
    private lazy var servicesLibrary: ServicesLibrary = {
        return ServicesLibrary(
            bsanManagersProvider: self.managersProviderAdapter.getPLManagerProvider(),
            bsanDataProvider: self.bsanDataProvider,
            networkProvider: networkProvider
        )
    }()
    private lazy var sessionDataManagerModifier: SessionDataManagerModifier = {
        return PLSessionDataManagerModifier(dependenciesEngine: dependencieEngine)
    }()
    // MARK: Features
//    private lazy var onboardingPermissionOptions: OnboardingPermissionOptions = {
//        return OnboardingPermissionOptions(dependenciesResolver: dependencieEngine)
//    }()
    private lazy var personalAreaSections: PersonalAreaSectionsProvider = {
        return PersonalAreaSectionsProvider(dependenciesResolver: dependencieEngine)
    }()
    
    private lazy var coreNotificationsService: CorePushNotificationsManagerProtocol = {
        return CorePushNotificationsManager(dependenciesResolver: dependencieEngine)
    }()
    
    private lazy var corePushNavigatorProvider: CorePushNavigatorProviderDelegate = {
        return CorePushNavigatorProvider(dependenciesResolver: dependencieEngine)
    }()
    
    private lazy var customPushLauncher: CustomPushLauncherProtocol = {
        return CustomPushLauncher(dependenciesResolver: dependencieEngine)
    }()
    private lazy var pfmController: PfmControllerProtocol = {
       return DefaultPFMController()
    }()

    // MARK: Dependencies init
    init() {
        self.dependencieEngine = DependenciesDefault()
        compilation = Compilation()
        versionInfo = VersionInfoDTO(
            bundleIdentifier: Bundle.main.bundleIdentifier ?? "",
            versionName: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
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
    // swiftlint:disable:next function_body_length
    func registerDependencies() {
        self.dependencieEngine.register(for: PLTrustedHeadersGenerable.self) { resolver in
            PLTrustedHeadersProvider(dependenciesResolver: resolver)
        }
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
        self.dependencieEngine.register(for: AppStoreInformationUseCase.self) { resolver in
            return PLAppStoreInformationUseCase()
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
        self.dependencieEngine.register(for: PLAccountOtherOperativesInfoRepository.self) { _ in
            return self.plAccountOtherOperativesInfoRepository
        }
        self.dependencieEngine.register(for: PLHelpCenterOnlineAdvisorRepository.self) { _ in
            return self.plHelpCenterOnlineAdvisorRepository
        }
        self.dependencieEngine.register(for: PLHelpQuestionsRepository.self) { _ in
            return self.plHelpQuestionsRepository
        }
        self.dependencieEngine.register(for: PLTransferSettingsRepository.self) { _ in
            return self.plTransferSettingsRepository
        }
        self.dependencieEngine.register(for: PLTermsAndConditionsRepository.self) { _ in
            return self.plTermsAndConditionsRepository
        }
        self.dependencieEngine.register(for: PLWebViewLinkRepositoryProtocol.self) { resolver in
            return PLWebViewLinkRepository(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: SiriAssistantProtocol.self) { _ in
            return EmptySiriAssistant()
        }
        self.dependencieEngine.register(for: TealiumCompilationProtocol.self) { _ in
            return TealiumCompilation()
        }
        self.dependencieEngine.register(for: SharedDependenciesDelegate.self) { _ in
            return self
        }
        self.dependencieEngine.register(for: ProductIdDelegateProtocol.self) { _ in
            return self.productIdDelegate
        }
        self.dependencieEngine.register(for: AdditionalUseCasesProviderProtocol.self) { resolver in
            return AdditionalUseCasesProviderImpl(dependencies: resolver)
        }
        self.dependencieEngine.register(for: ShareIbanFormatterProtocol.self) { _ in
            return self.ibanFormatter
        }
        self.dependencieEngine.register(for: AccountDetailModifierProtocol.self) { _ in
            return self.accountDetailModifier
        }
        self.dependencieEngine.register(for: AccountTransactionsPDFGeneratorProtocol.self) { _ in
            return self.accountTransactionsPDFModifier
        }
        self.dependencieEngine.register(for: PushNotificationPermissionsManagerProtocol.self) { _ in
            return self.notificationPermissionManager
        }
        self.dependencieEngine.register(for: NotificationsHandlerProtocol.self) { _ in
            self.notificationsHandler.addService(self.firebaseNotificationsService)
            return self.notificationsHandler
        }
        self.dependencieEngine.register(for: InboxActionBuilderProtocol.self) { resolver in
            return PLInboxActionBuilder(resolver: resolver)
        }
        self.dependencieEngine.register(for: GetFilteredAccountTransactionsUseCaseProtocol.self) { resolver in
            return PLGetFilteredAccountTransactionsUseCase(dependenciesResolver: resolver, bsanDataProvider: self.bsanDataProvider)
        }
        self.dependencieEngine.register(for: GetAccountTransactionsUseCaseProtocol.self) { resolver in
            return PLGetAccountTransactionsUseCase(dependenciesResolver: resolver, bsanDataProvider: self.bsanDataProvider)
        }
        self.dependencieEngine.register(for: AccountTransactionProtocol.self) { _ in
            return PLAccountTransaction()
        }
        self.dependencieEngine.register(for: LoanTransactionModifier.self) { _ in
            return PLLoanTransaction()
        }
        self.dependencieEngine.register(for: FiltersAlertModifier.self) { _ in
            return PLFiltersAlertModifier()
        }
        self.dependencieEngine.register(for: PersonalAreaSectionsProtocol.self) { _ in
            return self.personalAreaSections
        }
        self.dependencieEngine.register(for: GetBasePLWebConfigurationUseCaseProtocol.self) { resolver in
            return GetBasePLWebConfigurationUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: TransfersRepository.self) { _ in
            return self.servicesLibrary.transfersRepository
        }
        self.dependencieEngine.register(for: ContactsSortedHandlerProtocol.self) { _ in
            return ContactsSortedHandler()
        }
        self.dependencieEngine.register(for: OpinatorInfoOptionProtocol.self) { _ in
            PLOpinatorInfoOption()
        }
        self.dependencieEngine.register(for: BankingUtilsProtocol.self) { resolver in
            BankingUtils(dependencies: resolver)
        }
        self.dependencieEngine.register(for: PersonalDataModifier.self) { _ in
            PLPersonalDataModifier()
        }
        self.dependencieEngine.register(for: SessionDataManagerModifier.self) { _ in
            return self.sessionDataManagerModifier
        }
        self.dependencieEngine.register(for: SessionDataManager.self) { _ in
            return self.defaultSessionDataManager
        }
        self.dependencieEngine.register(for: LoadGlobalPositionUseCase.self) { resolver in
            return DefaultLoadGlobalPositionUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: SessionConfiguration.self) { _ in
            return SessionConfiguration(timeToExpireSession: self.timeToExpireSession,
                                        timeToRefreshToken: self.timeToRefreshToken,
                                        sessionStartedActions: [],
                                        sessionFinishedActions: [])
        }
        self.dependencieEngine.register(for: PfmHelperProtocol.self) { _ in
            return DefaultPFMHelper()
        }
        self.dependencieEngine.register(for: PfmControllerProtocol.self) { _ in
            return self.pfmController
        }
        self.dependencieEngine.register(for: ChallengesHandlerDelegate.self) { _ in
            return self
        }
        self.dependencieEngine.register(for: OneAuthorizationProcessorRepository.self) { _ in
            return self.servicesLibrary.oneAuthorizationProcessorRepository
        }
        registerDependenciesPL()
    }
    
    func registerDependenciesPL() {
        self.dependencieEngine.register(for: GetGenericErrorDialogDataUseCaseProtocol.self) { _ in
            return PLGetGenericErrorDialogDataUseCase()
        }
        self.dependencieEngine.register(for: PLOneAuthorizationProcessorRepository.self) { _ in
            return self.servicesLibrary.oneAuthorizationProcessorRepository
        }
        self.dependencieEngine.register(for: PrivateSideMenuModifier.self) { _ in
            PLPrivateSideMenuModifier()
        }
        self.dependencieEngine.register(for: PrivateMenuProtocol.self) { resolver in
            PLPrivateMenuModifier(resolver: resolver)
        }
        self.dependencieEngine.register(for: PersonalAreaMainModuleModifier.self) { resolver in
            PLPersonalAreaMainModuleModifier(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: PLTransfersRepository.self) { _ in
            return self.servicesLibrary.transfersRepository
        }
        self.dependencieEngine.register(for: GetPLAccountOtherOperativesWebConfigurationUseCase.self) { resolver in
            return GetPLAccountOtherOperativesWebConfigurationUseCase(dependenciesResolver: resolver, dataProvider: self.bsanDataProvider, networkProvider: self.networkProvider)
        }
        self.dependencieEngine.register(for: GetPLCardsOtherOperativesWebConfigurationUseCase.self) { resolver in
            return GetPLCardsOtherOperativesWebConfigurationUseCase(dependenciesResolver: resolver, dataProvider: self.bsanDataProvider, networkProvider: self.networkProvider)
        }
        self.dependencieEngine.register(for: CardTransactionDetailViewConfigurationProtocol.self) { _ in
            PLCardTransactionDetailViewConfiguration()
        }
        self.dependencieEngine.register(for: EditBudgetHelperModifier.self) { _ in
            PLEditBudgetHelperModifier()
        }
        self.dependencieEngine.register(for: ContextSelectorModifierProtocol.self) { resolver in
            PLContextSelectorModifier(dependenciesResolver: resolver, bsanDataProvider: self.bsanDataProvider)
        }
        self.dependencieEngine.register(for: AccountAvailableBalanceDelegate.self) { _ in
            PLAccountAvailableBalanceModifier()
        }
        
        self.dependencieEngine.register(for: EditBudgetHelperModifier.self) { _ in
            PLEditBudgetHelperModifier()
        }
        self.dependencieEngine.register(for: CorePushNavigatorProviderDelegate.self) { _ in
            return self.corePushNavigatorProvider
        }
        self.dependencieEngine.register(for: CorePushNotificationsManagerProtocol.self) { _ in
            return self.coreNotificationsService
        }
        
        self.dependencieEngine.register(for: CustomPushLauncherProtocol.self) { _ in
            return self.customPushLauncher
        }
        
        self.dependencieEngine.register(for: LoanReactiveRepository.self) { _ in
            return self.servicesLibrary.loanReactiveDataRepository
        }
        self.dependencieEngine.register(for: ProductAliasManagerProtocol.self) { _ in
            PLChangeAliasManager()
        }
        self.dependencieEngine.register(for: UserSegmentProtocol.self) { resolver in
            PLUserSegmentProtocol(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: OpinatorManagerModifier.self) { _ in
            PLOpinatorManagerModifier()
        }

        self.dependencieEngine.register(for: PLCardsHomeModuleCoordinatorApplePayProtocol.self) { resolver in
            return PLCardsHomeModuleCoordinatorApplePay(dependenciesResolver: resolver)
        }
    }
}

extension AppDependencies: SharedDependenciesDelegate {
    func publicFilesFinished(_ appConfigRepository: AppConfigRepositoryProtocol) {
    }
}

extension AppDependencies: ChallengesHandlerDelegate {
    func handle(_ challenge: ChallengeRepresentable, authorizationId: String, completion: @escaping (ChallengeResult) -> Void) {
        print(challenge)
    }
}

public class CorePushNavigatorProvider: CorePushNavigatorProviderDelegate {
    
    let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public func goToShowDialog(title: String?, message: String?, completion: (() -> Void)?) {
        debugPrint("goToShowDialog")
    }
    public func goToExternalURL(url: String) {
        debugPrint("goToExternalURL")
    }
    public func goToWebView(with url: String, title: String) {
        debugPrint("goToWebView")
    }
    public func goToLandingPush(cardTransactionInfo: CardTransactionPush?, cardAlert: CardAlertPush?) {
        debugPrint("goToLandingPush")
    }
    public func goToGenericLandingPush(accountTransactionInfo: AccountLandingPushDataBridge) {
        debugPrint("goToGenericLandingPush")
    }
}

class CustomPushLauncher: CustomPushLauncherProtocol {
    
    let dependenciesResolver: DependenciesResolver
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func executeActionForType(actionType: CustomPushLaunchActionTypeCapable) {
        if let actionType = actionType as? CustomPushLaunchActionTypeInfo {
            launchActionTypeInfo(actionType)
        } else if let actionType = actionType as? CustomPushLaunchActionTypeBlik {
            launchActionTypeBlik(actionType)
        } else if let actionType = actionType as? CustomPushLaunchActionTypeAlert {
            launchActionTypeAlert(actionType)
        } else if let actionType = actionType as? CustomPushLaunchActionTypeAuth {
            launchActionTypeAuth(actionType)
        } else {
            fatalError("not implemented")
        }
    }
    
    private func launchActionTypeInfo(_ actionType: CustomPushLaunchActionTypeInfo) {
        let coordinator = dependenciesResolver.resolve(for: CustomPushNotificationCoordinator.self)
        coordinator.start(actionType: actionType)
    }
    
    private func launchActionTypeBlik(_ actionType: CustomPushLaunchActionTypeBlik) {
        let coordinator = dependenciesResolver.resolve(for: BLIKHomeCoordinator.self)
        coordinator.start()
    }
        
    private func launchActionTypeAlert(_ actionType: CustomPushLaunchActionTypeAlert) {
         let coordinator = dependenciesResolver.resolve(for: CustomPushNotificationCoordinator.self)
         coordinator.start(actionType: actionType)
    }
    
    private func launchActionTypeAuth(_ actionType: CustomPushLaunchActionTypeAuth) {
         let coordinator = dependenciesResolver.resolve(for: CustomPushNotificationCoordinator.self)
         coordinator.start(actionType: actionType)
    }
}

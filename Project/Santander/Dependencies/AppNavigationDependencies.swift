//
//  AppNavigationDependencies.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

import LoginCommon
import PLLogin
import CoreFoundationLib
import PLCommons
import RetailLegacy
import PersonalArea
import BLIK
import PLHelpCenter
import CreditCardRepayment
import OneAuthorizationProcessor
import PLNotificationsInbox
import Inbox
import LoanSchedule
import TaxTransfer
import CharityTransfer
import PhoneTopUp
import Account
import Loans
import Cards
import ZusTransfer
import GlobalPosition

final class AppNavigationDependencies {
    private let drawer: BaseMenuViewController
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private lazy var sendMoneyCoordinator = SendMoneyCoordinator(
        dependenciesResolver: self.dependenciesEngine,
        drawer: self.drawer
    )
    private lazy var personalAreaModuleCoordinator = PersonalAreaModuleCoordinator(dependenciesResolver: self.dependenciesEngine, navigationController: (self.drawer.currentRootViewController as? UINavigationController)!)
    private let appSideMenuNavigationDependencies: AppSideMenuNavigationDependencies
    private lazy var authorizationCoordinator = PLAuthorizationCoordinator(dependenciesResolver: dependenciesEngine, navigationController: self.drawer.currentRootViewController as? UINavigationController)
    
    init(drawer: BaseMenuViewController, dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.drawer = drawer
        self.dependenciesEngine = dependenciesEngine
        self.appSideMenuNavigationDependencies = AppSideMenuNavigationDependencies(drawer: drawer, dependenciesEngine: dependenciesEngine)
    }
    
    func registerDependencies() {
        dependenciesEngine.register(for: LoginModuleCoordinatorProtocol.self) { resolver in
            return PLLoginModuleCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        
        dependenciesEngine.register(for: SendMoneyCoordinatorProtocol.self) { _ in
            return self.sendMoneyCoordinator
        }
        
        dependenciesEngine.register(for: PLLoginWebViewCoordinatorDelegate.self) { _ in
            return PLWebViewCoordinatorNavigator(dependenciesResolver: self.dependenciesEngine, drawer: self.drawer)
        }
        dependenciesEngine.register(for: PLWebViewCoordinatorDelegate.self) { _ in
            return PLWebViewCoordinatorNavigator(dependenciesResolver: self.dependenciesEngine, drawer: self.drawer)
        }
        
        dependenciesEngine.register(for: PersonalAreaModuleCoordinator.self) { _ in
            return self.personalAreaModuleCoordinator
        }
        dependenciesEngine.register(for: BLIKHomeCoordinator.self) { resolver in
            return BLIKHomeCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: TaxTransferFormCoordinatorProtocol.self) { _ in
            return TaxTransferFormCoordinator(dependenciesResolver: self.dependenciesEngine, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: CharityTransferModuleCoordinator.self) { resolver in
            let repository = resolver.resolve(for: PLTransferSettingsRepository.self)
            let charityTransfer = repository.get()?.charityTransfer
            let charityTransferSettings = CharityTransferSettings(transferRecipientName: charityTransfer?.transferRecipientName,
                                                                  transferAccountNumber: charityTransfer?.transferAccountNumber,
                                                                  transferTitle: charityTransfer?.transferTitle)
            return CharityTransferModuleCoordinator(dependenciesResolver: resolver,
                                                    charityTransferSettings: charityTransferSettings,
                                                    navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: PLHelpCenterModuleCoordinator.self) { resolver in
            return PLHelpCenterModuleCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: DeeplinkedBLIKConfirmationCoordinator.self) { resolver in
            return DeeplinkedBLIKConfirmationCoordinator(
                dependenciesResolver: resolver,
                navigationController: self.drawer.currentRootViewController as? UINavigationController
            )
        }
        dependenciesEngine.register(for: CreditCardRepaymentModuleCoordinator.self) { resolver in
            return CreditCardRepaymentModuleCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: OneAppInitCoordinatorProtocol.self) { [unowned self] _ in // Temporary [DEBUG MENU] on GlobalPosition
            return OneAppInitCoordinator(dependenciesEngine: self.dependenciesEngine, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: DebugMenuLauncherDelegate.self) { [unowned self] _ in // Temporary [DEBUG WELCOME] on Login
            return OneAppInitWelcomeCoordinator(dependenciesEngine: self.dependenciesEngine, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        self.dependenciesEngine.register(for: ChallengesHandlerDelegate.self) { _ in
            return self.authorizationCoordinator
        }
        
        dependenciesEngine.register(for: CustomPushNotificationCoordinator.self) { resolver in
            return CustomPushNotificationCoordinator(dependenciesResolver: resolver,
                                     navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        
        dependenciesEngine.register(for: PLWebViewCoordinatorDelegate.self) { [unowned self] resolver in
            return PLWebViewCoordinatorNavigator(dependenciesResolver: resolver, drawer: self.drawer)
        }

        dependenciesEngine.register(for: InboxNotificationCoordinatorDelegate.self) { _ in
            return PLInboxNotificationCoordinator(dependenciesResolver: self.dependenciesEngine)
        }
        
        dependenciesEngine.register(for: LoanScheduleModuleCoordinator.self) { resolver in
            return LoanScheduleModuleCoordinator(dependenciesResolver: resolver, navigationController: self.drawer.currentRootViewController as? UINavigationController)
        }
        dependenciesEngine.register(for: TopUpDataLoaderCoordinatorProtocol.self) { resolver in
            let repository = resolver.resolve(for: PLTransferSettingsRepository.self)
            let settingsDto = repository.get()?.topup ?? []
            let topUpSettings = settingsDto
                .compactMap({ TopUpOperatorSettings(operatorId: $0.id, defaultTopUpValue: $0.defValue, requestAcceptance: $0.reqAcceptance) })
            return TopUpDataLoaderCoordinator(dependenciesResolver: resolver,
                                              navigationController: self.drawer.currentRootViewController as? UINavigationController,
                                              settings: topUpSettings)
        }
        dependenciesEngine.register(for: ZusTransferModuleCoordinatorProtocol.self) { resolver in
            let repository = resolver.resolve(for: PLTransferSettingsRepository.self)
            return ZusTransferModuleCoordinator(
                dependenciesResolver: resolver,
                navigationController: self.drawer.currentRootViewController as? UINavigationController,
                validationMask: repository.get()?.zusTransfer?.mask
            )
        }
        dependenciesEngine.register(for: AccountTransactionDetailActionProtocol.self) { resolver in
            return PLAccountTransactionDetailAction(dependenciesResolver: resolver, drawer: self.drawer)
        }
        dependenciesEngine.register(for: LoanTransactionActionsModifier.self) { resolver in
            return PLLoanTransactionActionsModifier(dependenciesResolver: resolver, drawer: self.drawer)
        }
        dependenciesEngine.register(for: CardTransactionDetailActionFactoryModifierProtocol.self) { resolver in
            return PLCardTransactionDetailActionFactoryModifier(dependenciesResolver: resolver, drawer: self.drawer)
        }
        appSideMenuNavigationDependencies.registerDependencies()
        DeeplinkDependencies(drawer: drawer, dependenciesEngine: dependenciesEngine).registerDependencies()
        self.dependenciesEngine.register(for: InsuranceProtectionModifier.self) { resolver in
            PLInsuranceProtectionModifier(dependenciesResolver: resolver, drawer: self.drawer)
        }
    }
}

extension OneAppInitWelcomeCoordinator: DebugMenuLauncherDelegate {} // Temporary [DEBUG WELCOME] on Login

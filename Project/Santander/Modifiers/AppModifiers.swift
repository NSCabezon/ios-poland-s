//
//  AppModifiers.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 04/02/2021.
//

import PLNotificationsInbox
import TransferOperatives
import CoreFoundationLib
import SANLegacyLibrary
import GlobalPosition
import PersonalArea
import RetailLegacy
import PrivateMenu
import PLCommons
import Transfer
import Account
import Cards
import Loans
import UI

final class AppModifiers {
    private let legacyDependenciesInjector: DependenciesInjector
    private let legacyDependenciesResolver: DependenciesResolver
    private let dependencies: ModuleDependencies
    private lazy var depositModifiers: GlobalPosition.DepositModifier = {
        let depositModifier = PLDepositModifier(dependenciesResolver: self.legacyDependenciesResolver)
        return depositModifier
    }()
    private lazy var fundModifiers: GlobalPosition.FundModifier = {
        let fundModifier = FundModifier(dependenciesResolver: self.legacyDependenciesResolver)
        return fundModifier
    }()
    private lazy var cardHomeActionModifier: PLCardHomeActionModifier = {
        let modifier = PLCardHomeActionModifier(dependenciesResolver: self.legacyDependenciesResolver)
        modifier.setCompletion { resolver in
            modifier.add(PLCardHomeActionModifier(dependenciesResolver: resolver))
        }
        return modifier
    }()
    private lazy var cardHomeModifier: CardHomeModifierProtocol = {
        return PLCardHomeModifier(dependencies: dependencies)
    }()
    private lazy var accountHomeActionModifier: AccountHomeActionModifierProtocol = {
        return PLAccountHomeActionModifier(dependencies: self.dependencies)
    }()
    private lazy var currencyProvider: AmountFormatterProvider & CurrencyFormatterProvider = {
        return PLNumberFormatter()
    }()
    private lazy var getGPCardsOperativeOptionProtocol: GetGPCardOperativeModifier = {
        return GetGPCardOperativeModifier()
    }()
    private lazy var getGPAccountsOperativeOptionProtocol: GetGPAccountOperativeModifier = {
        return GetGPAccountOperativeModifier(dependencies: dependencies)
    }()
    private lazy var getGPLoanOperativeOptionProtocol: GetGPLoanOperativeModifier = {
        return GetGPLoanOperativeModifier()
    }()
    private lazy var getGPInsuranceProtectionOperativeOptionProtocol: GetGPInsuranceProtectionOperativeModifier = {
        return GetGPInsuranceProtectionOperativeModifier()
    }()
    private lazy var getGPInvestmentFundOperativeOptionProtocol: GetGPInvestmentFundOperativeOptionModifier = {
        return GetGPInvestmentFundOperativeOptionModifier()
    }()
    private lazy var getGPOtherOperativeOptionProtocol: GetGPOtherOperativeModifier = {
        return GetGPOtherOperativeModifier()
    }()
    private lazy var otherOperativesModifier: OtherOperativesModifierProtocol = {
        return OtherOperativesModifier(dependencies: dependencies, dependenciesResolver: legacyDependenciesResolver)
    }()
    private lazy var cardTransactionsSearchModifier: CardTransactionsSearchModifierProtocol = {
        return PLCardTransactionsSearchModifier()
    }()
    private lazy var personalAreaSectionsSecurityModifier: PersonalAreaSectionsSecurityModifierProtocol = {
        return PLPersonalAreaSectionsSecurityModifier()
    }()
    private lazy var getPGFrequentOperativeOption: GetPGFrequentOperativeOptionProtocol = {
        return GetPGFrequentOperativeOption(dependencies: dependencies)
    }()
    init(dependencies: ModuleDependencies) {
        self.legacyDependenciesInjector = dependencies.resolve()
        self.legacyDependenciesResolver = dependencies.resolve()
        self.dependencies = dependencies
        self.registerDependencies()
    }
}

private extension AppModifiers {
    func registerDependencies() {
        self.legacyDependenciesInjector.register(for: DepositModifier.self) { _ in
            return self.depositModifiers
        }
        self.legacyDependenciesInjector.register(for: FundModifier.self) { _ in
            return self.fundModifiers
        }
        self.legacyDependenciesInjector.register(for: SecurityAreaActionProtocol.self) { resolver in
            return PLSecurityActionFactory(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: GlobalSecurityViewContainerProtocol.self) { resolver in
            return PLGlobalSecurityViewContainer(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: AccountNumberFormatterProtocol.self) { _ in
            return PLAccountNumberFormatter()
        }
        self.legacyDependenciesInjector.register(for: CardHomeActionModifier.self) { _ in
            return self.cardHomeActionModifier
        }
        self.legacyDependenciesInjector.register(for: CardBoardingActionModifierProtocol.self) { _ in
            return self.cardHomeActionModifier
        }
        self.legacyDependenciesInjector.register(for: SetupActivateCardUseCaseProtocol.self) { resolver in
            return PLSetupActivateCardUseCase(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: CardActionFactoryProtocol.self) { dependenciesResolver in
            return PLCardActionFactory(dependenciesResolver: dependenciesResolver)
        }
        self.legacyDependenciesInjector.register(for: CardHomeModifierProtocol.self) { _ in
            return self.cardHomeModifier
        }
        self.legacyDependenciesInjector.register(for: GetMonthlyBalanceUseCase.self) { resolver in
            return MonthlyBalanceUseCase(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: AmountFormatterProvider.self) { _ in
            return self.currencyProvider
        }
        self.legacyDependenciesInjector.register(for: CurrencyFormatterProvider.self) { _ in
            return self.currencyProvider
        }
        self.legacyDependenciesInjector.register(for: GetGPCardsOperativeOptionProtocol.self) { _ in
            return self.getGPCardsOperativeOptionProtocol
        }
        self.legacyDependenciesInjector.register(for: GetGPAccountOperativeOptionProtocol.self) { _ in
            return self.getGPAccountsOperativeOptionProtocol
        }
        self.legacyDependenciesInjector.register(for: GetGPLoanOperativeOptionProtocol.self) { _ in
            return self.getGPLoanOperativeOptionProtocol
        }
        self.legacyDependenciesInjector.register(for: GetGPInsuranceProtectionOperativeOptionProtocol.self) { _ in
            return self.getGPInsuranceProtectionOperativeOptionProtocol
        }
        self.legacyDependenciesInjector.register(for: GetGPInvestmentFundOperativeOptionProtocol.self) { _ in
            return self.getGPInvestmentFundOperativeOptionProtocol
        }
        self.legacyDependenciesInjector.register(for: GetGPOtherOperativeOptionProtocol.self) { _ in
            return self.getGPOtherOperativeOptionProtocol
        }
        self.legacyDependenciesInjector.register(for: OtherOperativesModifierProtocol.self) { _ in
            return self.otherOperativesModifier
        }
        self.legacyDependenciesInjector.register(for: GetPersonalBasicInfoUseCaseProtocol.self) { resolver in
            return PLGetPersonalBasicInfoUseCase(dependencies: resolver)
        }
        self.legacyDependenciesInjector.register(for: AccountTransactionProtocol.self) { _ in
            return PLAccountTransaction()
        }
        self.legacyDependenciesInjector.register(for: CardTransactionsSearchModifierProtocol.self) { _ in
            return self.cardTransactionsSearchModifier
        }
        self.legacyDependenciesInjector.register(for: OnboardingPermissionOptionsProtocol.self) { _ in
            return OnboardingPermissionOptions()
        }
        self.legacyDependenciesInjector.register(for: PersonalAreaSectionsSecurityModifierProtocol.self) { _ in
            return self.personalAreaSectionsSecurityModifier
        }
        self.legacyDependenciesInjector.register(for: AccountTransactionDetailProtocol.self) { _ in
            return PLAccountTransactionDetail()
        }
        self.legacyDependenciesInjector.register(for: GetAccountHomeActionUseCaseProtocol.self) { resolver in
            return GetPLAccountHomeActionUseCase(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: GetAccountOtherOperativesActionUseCaseProtocol.self) { resolver in
            return GetPLAccountOtherOperativesActionUseCase(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: AccountHomeActionModifierProtocol.self) { _ in
            return self.accountHomeActionModifier
        }
        self.legacyDependenciesInjector.register(for: AccountTransactionDetailShareableInfoProtocol.self) { _ in
            return PLAccountTransactionDetailShareableInfo()
        }
        self.legacyDependenciesInjector.register(for: AccountOtherOperativesActionModifierProtocol.self) { resolver in
            return PLAccountOtherOperativesActionModifier(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: AccountsHomePresenterModifier.self) { _ in
            return PLAccountsHomePresenterModifier()
        }
        SendMoneyDependencies(legacyDependenciesInjector: legacyDependenciesInjector).registerDependencies()
        self.legacyDependenciesInjector.register(for: OpinatorInfoOptionProtocol.self) { _ in
            return PLOpinatorInfoOption()
        }
        self.legacyDependenciesInjector.register(for: GetCardOnOffPredefinedSCAUseCaseProtocol.self) { resolver in
            PLGetCardOnOffPredefinedSCAUseCase(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: ValidateCardOnOffUseCaseProtocol.self) { resolver in
            PLValidateCardOnOffUseCase(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: SendMoneyConfirmationStepUseCaseProtocol.self) { resolver in
            PLSendMoneyConfirmationStepUseCase(dependenciesResolver: resolver)
        }
        self.legacyDependenciesInjector.register(for: GenericDialogAddBranchLocatorActionCapable.self) { _ in
            GenericDialogActionsModifier()
        }
        self.legacyDependenciesInjector.register(for: GetPGFrequentOperativeOptionProtocol.self) { _ in
            return self.getPGFrequentOperativeOption
        }
        self.legacyDependenciesInjector.register(for: PrivateMenuProtocol.self) { _ in
            PLPrivateMenuModifier(dependencies: self.dependencies)
        }
        self.legacyDependenciesInjector.register(for: ShortcutItemsProviderProtocol.self) { _ in
            return PLShortcutItems()
        }
        self.legacyDependenciesInjector.register(for: InternalTransferAmountModifierProtocol.self) { _ in
            return PLInternalTransferAmountModifier()
        }
    }
}

//
//  AppModifiers.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 04/02/2021.
//

import RetailLegacy
import CoreFoundationLib
import GlobalPosition
import Transfer
import Cards
import Account
import PLCommons
import Loans
import PersonalArea
import SANLegacyLibrary
import TransferOperatives
import UI
import PLNotificationsInbox

final class AppModifiers {
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let moduleDependencies: ModuleDependencies
    private lazy var depositModifiers: GlobalPosition.DepositModifier = {
        let depositModifier = PLDepositModifier(dependenciesResolver: self.dependenciesEngine)
        return depositModifier
    }()
    private lazy var fundModifiers: GlobalPosition.FundModifier = {
        let fundModifier = PLFundModifier(dependenciesResolver: self.dependenciesEngine)
        return fundModifier
    }()
    private lazy var cardHomeActionModifier: PLCardHomeActionModifier = {
        let modifier = PLCardHomeActionModifier(dependenciesResolver: self.dependenciesEngine)
        modifier.setCompletion { resolver in
            modifier.add(PLCardHomeActionModifier(dependenciesResolver: resolver))
        }
        return modifier
    }()
    private lazy var cardHomeModifier: CardHomeModifierProtocol = {
        return PLCardHomeModifier(dependenciesEngine: dependenciesEngine)
    }()
    private lazy var cardDetailModifier: CardDetailModifierProtocol = {
        return PLCardDetailModifier(dependenciesEngine: dependenciesEngine)
    }()
    private lazy var loanDetailModifier: LoanDetailModifierProtocol = {
        return PLLoanDetailModifier(dependenciesEngine: dependenciesEngine)
    }()
    private lazy var currencyProvider: AmountFormatterProvider & CurrencyFormatterProvider = {
        return PLNumberFormatter()
    }()
    private lazy var getGPCardsOperativeOptionProtocol: GetGPCardOperativeModifier = {
        return GetGPCardOperativeModifier()
    }()
    private lazy var getGPAccountsOperativeOptionProtocol: GetGPAccountOperativeModifier = {
        return GetGPAccountOperativeModifier(moduleDependencies: moduleDependencies)
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
        return OtherOperativesModifier(dependenciesEngine: dependenciesEngine)
    }()
    private lazy var cardTransactionsSearchModifier: CardTransactionsSearchModifierProtocol = {
        return PLCardTransactionsSearchModifier(dependenciesEngine: dependenciesEngine)
    }()
    private lazy var personalAreaSectionsSecurityModifier: PersonalAreaSectionsSecurityModifierProtocol = {
        return PLPersonalAreaSectionsSecurityModifier(dependenciesEngine: dependenciesEngine)
    }()
    private lazy var getPGFrequentOperativeOption: GetPGFrequentOperativeOptionProtocol = {
        return GetPGFrequentOperativeOption(moduleDependencies: moduleDependencies)
    }()
    init(dependenciesEngine: DependenciesResolver & DependenciesInjector, moduleDependencies: ModuleDependencies) {
        self.dependenciesEngine = dependenciesEngine
        self.moduleDependencies = moduleDependencies
        self.registerDependencies()
    }
}

private extension AppModifiers {
    func registerDependencies() {
        self.dependenciesEngine.register(for: DepositModifier.self) { _ in
            return self.depositModifiers
        }
        self.dependenciesEngine.register(for: FundModifier.self) { _ in
            return self.fundModifiers
        }
        self.dependenciesEngine.register(for: AccountNumberFormatterProtocol.self) { _ in
            return PLAccountNumberFormatter()
        }
        self.dependenciesEngine.register(for: CardHomeActionModifier.self) { _ in
            return self.cardHomeActionModifier
        }
        self.dependenciesEngine.register(for: CardBoardingActionModifierProtocol.self) { _ in
            return self.cardHomeActionModifier
        }
        self.dependenciesEngine.register(for: SetupActivateCardUseCaseProtocol.self) { resolver in
            return PLSetupActivateCardUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: CardActionFactoryProtocol.self) { dependenciesResolver in
            return PLCardActionFactory(dependenciesResolver: dependenciesResolver)
        }
        self.dependenciesEngine.register(for: CardHomeModifierProtocol.self) { _ in
            return self.cardHomeModifier
        }
        self.dependenciesEngine.register(for: CardDetailModifierProtocol.self) { _ in
            return self.cardDetailModifier
        }
        
        self.dependenciesEngine.register(for: GetMonthlyBalanceUseCase.self) { resolver in
            return MonthlyBalanceUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: LoanDetailModifierProtocol.self) { _ in
            return self.loanDetailModifier
        }
        self.dependenciesEngine.register(for: AmountFormatterProvider.self) { _ in
            return self.currencyProvider
        }
        self.dependenciesEngine.register(for: CurrencyFormatterProvider.self) { _ in
            return self.currencyProvider
        }
        self.dependenciesEngine.register(for: GetGPCardsOperativeOptionProtocol.self) { _ in
            return self.getGPCardsOperativeOptionProtocol
        }
        self.dependenciesEngine.register(for: GetGPAccountOperativeOptionProtocol.self) { _ in
            return self.getGPAccountsOperativeOptionProtocol
        }
        self.dependenciesEngine.register(for: GetGPLoanOperativeOptionProtocol.self) { _ in
            return self.getGPLoanOperativeOptionProtocol
        }
        self.dependenciesEngine.register(for: GetGPInsuranceProtectionOperativeOptionProtocol.self) { _ in
            return self.getGPInsuranceProtectionOperativeOptionProtocol
        }
        self.dependenciesEngine.register(for: GetGPInvestmentFundOperativeOptionProtocol.self) { _ in
            return self.getGPInvestmentFundOperativeOptionProtocol
        }
        self.dependenciesEngine.register(for: GetGPOtherOperativeOptionProtocol.self) { _ in
            return self.getGPOtherOperativeOptionProtocol
        }
        self.dependenciesEngine.register(for: OtherOperativesModifierProtocol.self) { _ in
            return self.otherOperativesModifier
        }
        self.dependenciesEngine.register(for: GetPersonalBasicInfoUseCaseProtocol.self) { resolver in
            return PLGetPersonalBasicInfoUseCase(dependencies: resolver)
        }
        self.dependenciesEngine.register(for: AccountTransactionProtocol.self) { _ in
            return PLAccountTransaction()
        }
        self.dependenciesEngine.register(for: CardTransactionsSearchModifierProtocol.self) { _ in
            return self.cardTransactionsSearchModifier
        }
        self.dependenciesEngine.register(for: OnboardingPermissionOptionsProtocol.self) { _ in
            return OnboardingPermissionOptions()
        }
        self.dependenciesEngine.register(for: PersonalAreaSectionsSecurityModifierProtocol.self) { _ in
            return self.personalAreaSectionsSecurityModifier
        }
        self.dependenciesEngine.register(for: AccountTransactionDetailProtocol.self) { _ in
            return PLAccountTransactionDetail()
        }
        self.dependenciesEngine.register(for: GetAccountHomeActionUseCaseProtocol.self) { resolver in
            return GetPLAccountHomeActionUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: GetAccountOtherOperativesActionUseCaseProtocol.self) { resolver in
            return GetPLAccountOtherOperativesActionUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: AccountHomeActionModifierProtocol.self) { _ in
            return PLAccountHomeActionModifier(moduleDependencies: self.moduleDependencies)
        }
        self.dependenciesEngine.register(for: AccountTransactionDetailShareableInfoProtocol.self) { _ in
            return PLAccountTransactionDetailShareableInfo()
        }
        self.dependenciesEngine.register(for: AccountOtherOperativesActionModifierProtocol.self) { resolver in
            return PLAccountOtherOperativesActionModifier(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: AccountsHomePresenterModifier.self) { _ in
            return PLAccountsHomePresenterModifier()
        }
        SendMoneyDependencies(dependenciesEngine: self.dependenciesEngine).registerDependencies()
        self.dependenciesEngine.register(for: OpinatorInfoOptionProtocol.self) { _ in
            return PLOpinatorInfoOption()
        }
        self.dependenciesEngine.register(for: GetCardOnOffPredefinedSCAUseCaseProtocol.self) { resolver in
            PLGetCardOnOffPredefinedSCAUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: ValidateCardOnOffUseCaseProtocol.self) { resolver in
            PLValidateCardOnOffUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: SendMoneyConfirmationStepUseCaseProtocol.self) { resolver in
            PLSendMoneyConfirmationStepUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: GenericDialogAddBranchLocatorActionCapable.self) { _ in
            GenericDialogActionsModifier()
        }
        self.dependenciesEngine.register(for: LoanTransactionDetailUseCaseProtocol.self) { dependenciesResolver in
            PLLoanTransactionDetailUseCase(dependenciesResolver: dependenciesResolver)
        }
        self.dependenciesEngine.register(for: GetPGFrequentOperativeOptionProtocol.self) { _ in
            return self.getPGFrequentOperativeOption
        }
        self.dependenciesEngine.register(for: PrivateMenuProtocol.self) { resolver in
            PLPrivateMenuModifier(moduleDependencies: self.moduleDependencies)
        }
        self.dependenciesEngine.register(for: ShortcutItemsProviderProtocol.self) { _ in
            return PLShortcutItems()
        }
    }
}

//
//  AppModifiers.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 04/02/2021.
//

import Models
import RetailLegacy
import Commons
import GlobalPosition
import Transfer
import Cards
import Account
import PLCommons
import Loans
import PersonalArea
import SANLegacyLibrary
import DomainCommon
import TransferOperatives
import UI

final class AppModifiers {
    private let dependencieEngine: DependenciesResolver & DependenciesInjector
    private lazy var depositModifiers: GlobalPosition.DepositModifier = {
        let depositModifier = PLDepositModifier(dependenciesResolver: self.dependencieEngine)
        return depositModifier
    }()
    private lazy var fundModifiers: GlobalPosition.FundModifier = {
        let fundModifier = PLFundModifier(dependenciesResolver: self.dependencieEngine)
        return fundModifier
    }()
    private lazy var cardHomeActionModifier: Cards.CardHomeActionModifier = {
        let modifier = CardHomeActionModifier(dependenciesResolver: self.dependencieEngine)
        modifier.setCompletion { resolver in
            modifier.add(PLCardHomeActionModifier(dependenciesResolver: resolver))
        }
        return modifier
    }()
    private lazy var cardHomeModifier: CardHomeModifierProtocol = {
        return PLCardHomeModifier(dependenciesEngine: dependencieEngine)
    }()
    private lazy var cardDetailModifier: CardDetailModifierProtocol = {
        return PLCardDetailModifier(dependenciesEngine: dependencieEngine)
    }()
    private lazy var loansModifier: LoansModifierProtocol = {
        return PLLoanModifier(dependenciesEngine: dependencieEngine)
    }()
    private lazy var loanDetailModifier: LoanDetailModifierProtocol = {
        return PLLoanDetailModifier(dependenciesEngine: dependencieEngine)
    }()
    private lazy var currencyProvider: AmountFormatterProvider & CurrencyFormatterProvider = {
        return PLNumberFormatter()
    }()
    private lazy var getGPCardsOperativeOptionProtocol: GetGPCardOperativeModifier = {
        return GetGPCardOperativeModifier()
    }()
    private lazy var getGPAccountsOperativeOptionProtocol: GetGPAccountOperativeModifier = {
        return GetGPAccountOperativeModifier(dependenciesEngine: self.dependencieEngine)
    }()
    private lazy var getGPLoanOperativeOptionProtocol: GetGPLoanOperativeModifier = {
        return GetGPLoanOperativeModifier()
    }()
    private lazy var getGPInsuranceProtectionOperativeOptionProtocol: GetGPInsuranceProtectionOperativeModifier = {
        return GetGPInsuranceProtectionOperativeModifier()
    }()
    private lazy var getGPOtherOperativeOptionProtocol: GetGPOtherOperativeModifier = {
        return GetGPOtherOperativeModifier()
    }()
    private lazy var otherOperativesModifier: OtherOperativesModifierProtocol = {
        return OtherOperativesModifier(dependenciesEngine: dependencieEngine)
    }()
    private lazy var cardTransactionsSearchModifier: CardTransactionsSearchModifierProtocol = {
        return PLCardTransactionsSearchModifier(dependenciesEngine: dependencieEngine)
    }()
    private lazy var personalAreaSectionsSecurityModifier: PersonalAreaSectionsSecurityModifierProtocol = {
        return PLPersonalAreaSectionsSecurityModifier(dependenciesEngine: dependencieEngine)
    }()
    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependencieEngine = dependenciesEngine
        self.registerDependencies()
    }
}

private extension AppModifiers {
    func registerDependencies() {
        self.dependencieEngine.register(for: DepositModifier.self) { _ in
            return self.depositModifiers
        }
        self.dependencieEngine.register(for: FundModifier.self) { _ in
            return self.fundModifiers
        }
        self.dependencieEngine.register(for: AccountNumberFormatterProtocol.self) { _ in
            return PLAccountNumberFormatter()
        }
        self.dependencieEngine.register(for: CardHomeActionModifier.self) { _ in
            return self.cardHomeActionModifier
        }
        self.dependencieEngine.register(for: SetupActivateCardUseCaseProtocol.self) { resolver in
            return PLSetupActivateCardUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: CardHomeModifierProtocol.self) { _ in
            return self.cardHomeModifier
        }
        self.dependencieEngine.register(for: CardDetailModifierProtocol.self) { _ in
            return self.cardDetailModifier
        }
        self.dependencieEngine.register(for: MonthlyBalanceUseCaseProtocol.self) { resolver in
            return MonthlyBalanceUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: LoansModifierProtocol.self) { _ in
            return self.loansModifier
        }
        self.dependencieEngine.register(for: LoanDetailModifierProtocol.self) { _ in
            return self.loanDetailModifier
        }
        self.dependencieEngine.register(for: AmountFormatterProvider.self) { _ in
            return self.currencyProvider
        }
        self.dependencieEngine.register(for: CurrencyFormatterProvider.self) { _ in
            return self.currencyProvider
        }
        self.dependencieEngine.register(for: GetGPCardsOperativeOptionProtocol.self) { _ in
            return self.getGPCardsOperativeOptionProtocol
        }
        self.dependencieEngine.register(for: GetGPAccountOperativeOptionProtocol.self) { _ in
            return self.getGPAccountsOperativeOptionProtocol
        }
        self.dependencieEngine.register(for: GetGPLoanOperativeOptionProtocol.self) { _ in
            return self.getGPLoanOperativeOptionProtocol
        }
        self.dependencieEngine.register(for: GetGPInsuranceProtectionOperativeOptionProtocol.self) { _ in
            return self.getGPInsuranceProtectionOperativeOptionProtocol
        }
        self.dependencieEngine.register(for: GetGPOtherOperativeOptionProtocol.self) { _ in
            return self.getGPOtherOperativeOptionProtocol
        }
        self.dependencieEngine.register(for: OtherOperativesModifierProtocol.self) { _ in
            return self.otherOperativesModifier
        }
        self.dependencieEngine.register(for: GetPersonalBasicInfoUseCaseProtocol.self) { resolver in
            return PLGetPersonalBasicInfoUseCase(dependencies: resolver)
        }
        self.dependencieEngine.register(for: AccountTransactionProtocol.self) { _ in
            return PLAccountTransaction()
        }
        self.dependencieEngine.register(for: CardTransactionsSearchModifierProtocol.self) { _ in
            return self.cardTransactionsSearchModifier
        }
        self.dependencieEngine.register(for: OnboardingPermissionOptionsProtocol.self) { _ in
            return OnboardingPermissionOptions()
        }
        self.dependencieEngine.register(for: PersonalAreaSectionsSecurityModifierProtocol.self) { _ in
            return self.personalAreaSectionsSecurityModifier
        }
        self.dependencieEngine.register(for: AccountTransactionDetailProtocol.self) { _ in
            return PLAccountTransactionDetail()
        }
        self.dependencieEngine.register(for: AccountTransactionDetailActionProtocol.self) { _ in
            return PLAccountTransactionDetailAction()
        }
        self.dependencieEngine.register(for: GetAccountHomeActionUseCaseProtocol.self) { resolver in
            return GetPLAccountHomeActionUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: GetAccountOtherOperativesActionUseCaseProtocol.self) { resolver in
            return GetPLAccountOtherOperativesActionUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: AccountHomeActionModifierProtocol.self) { resolver in
            return PLAccountHomeActionModifier(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: AccountTransactionDetailShareableInfoProtocol.self) { _ in
            return PLAccountTransactionDetailShareableInfo()
        }
        self.dependencieEngine.register(for: AccountOtherOperativesActionModifierProtocol.self) { resolver in
            return PLAccountOtherOperativesActionModifier(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: AccountsHomePresenterModifier.self) { _ in
            return PLAccountsHomePresenterModifier()
        }
        SendMoneyDependencies(dependenciesEngine: self.dependencieEngine).registerDependencies()
        self.dependencieEngine.register(for: OpinatorInfoOptionProtocol.self) { _ in
            return PLOpinatorInfoOption()
        }
        self.dependencieEngine.register(for: GetCardOnOffPredefinedSCAUseCaseProtocol.self) { resolver in
            PLGetCardOnOffPredefinedSCAUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: ValidateCardOnOffUseCaseProtocol.self) { resolver in
            PLValidateCardOnOffUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: SendMoneyConfirmationStepUseCaseProtocol.self) { resolver in
            PLSendMoneyConfirmationStepUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: GenericDialogAddBranchLocatorActionCapable.self) { _ in
            GenericDialogActionsModifier()
        }
    }
}

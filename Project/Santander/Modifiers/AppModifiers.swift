//
//  AppModifiers.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 04/02/2021.
//

//import UI
//import Models
import Commons
import GlobalPosition
import Transfer
import Cards
import Account
import Loans

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
    private lazy var accountHomeActionModifier: Account.AccountHomeActionModifier = {
        let modifier = AccountHomeActionModifier(dependenciesResolver: self.dependencieEngine)
        modifier.setCompletion { resolver in
            modifier.add(PLAccountHomeActionModifier(dependenciesResolver: resolver))
        }
        return modifier
    }()
    private lazy var accountOtherOperativesActionModifier: Account.AccountOtherOperativesActionModifier = {
        let modifier = AccountOtherOperativesActionModifier(dependenciesResolver: self.dependencieEngine)
        modifier.setCompletion { resolver in
            modifier.add(PLAccountOtherOperativesActionModifier(dependenciesResolver: resolver))
        }
        return modifier
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
    private lazy var loansModifier: LoansModifierProtocol = {
        return PLLoanModifier(dependenciesEngine: dependencieEngine)
    }()
    private lazy var currencyProvider: AmountFormatterProvider & CurrencyFormatterProvider = {
        return PLNumberFormatter()
    }()
    private lazy var getGPCardsOperativeOptionProtocol: GetGPCardOperativeModifier = {
        return GetGPCardOperativeModifier()
    }()
    private lazy var getGPAccountsOperativeOptionProtocol: GetGPAccountOperativeModifier = {
        return GetGPAccountOperativeModifier()
    }()
    private lazy var getGPInsuranceProtectionOperativeOptionProtocol: GetGPInsuranceProtectionOperativeModifier = {
        return GetGPInsuranceProtectionOperativeModifier()
    }()
    private lazy var getGPOtherOperativeOptionProtocol: GetGPOtherOperativeModifier = {
        return GetGPOtherOperativeModifier()
    }()
    private lazy var otherOperativesModifier: OtherOperativesModifierProtocol = {
        return OtherOperativesModifier()
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
        self.dependencieEngine.register(for: AccountHomeActionModifier.self) { _ in
            return self.accountHomeActionModifier
        }
        self.dependencieEngine.register(for: AccountOtherOperativesActionModifier.self) { _ in
            return self.accountOtherOperativesActionModifier
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
        self.dependencieEngine.register(for: CardHomeModifierProtocol.self) { resolver in
            return self.cardHomeModifier
        }
        self.dependencieEngine.register(for: MonthlyBalanceUseCaseProtocol.self) { resolver in
            return MonthlyBalanceUseCase(dependenciesResolver: resolver)
        }
        self.dependencieEngine.register(for: LoansModifierProtocol.self) { resolver in
            return self.loansModifier
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
        self.dependencieEngine.register(for: GetGPInsuranceProtectionOperativeOptionProtocol.self) { _ in
            return self.getGPInsuranceProtectionOperativeOptionProtocol
        }
        self.dependencieEngine.register(for: GetGPOtherOperativeOptionProtocol.self) { _ in
            return self.getGPOtherOperativeOptionProtocol
        }
        self.dependencieEngine.register(for: AccountHomeActionModifier.self) { _ in
            return self.accountHomeActionModifier
        }
        self.dependencieEngine.register(for: OtherOperativesModifierProtocol.self) { resolver in
            return self.otherOperativesModifier
        }
//        self.dependencieEngine.register(for: TransferHomeActionModifier.self) { _ in
//            return self.transferHomeActionModifier
//        }
//        self.dependencieEngine.register(for: AccountOtherOperativesActionModifier.self) { _ in
//            return self.accountOtherOperativesActionModifier
//        }
//        self.dependencieEngine.register(for: GetDepositWebViewConfigurationUseCase.self) { resolver in
//            return GetDepositWebViewConfigurationUseCase(dependenciesResolver: resolver)
//        }
//        self.dependencieEngine.register(for: GetFundWebViewConfigurationUseCase.self) { resolver in
//            return GetFundWebViewConfigurationUseCase(dependenciesResolver: resolver)
//        }
//        self.dependencieEngine.register(for: GetPTWebViewConfigurationUseCase.self) { resolver in
//            return GetPTWebViewConfigurationUseCase(dependenciesResolver: resolver)
//        }
//        self.dependencieEngine.register(for: PINProviderCipherProtocol.self) { resolver in
//            return PINProviderCipher()
//        }
//        self.dependencieEngine.register(for: PINProviderProtocol.self) { resolver in
//            return PINProvider(cryptoCipher: resolver.resolve(for: PINProviderCipherProtocol.self))
//        }
//        self.dependencieEngine.register(for: GetPersistedUserUseCaseProtocol.self) { resolver in
//            return GetPersistedUserUseCase(dependenciesResolver: resolver)
//        }
//        self.dependencieEngine.register(for: SetPersistedUserUseCaseProtocol.self) { resolver in
//            return SetPersistedUserUseCase(dependenciesResolver: resolver)
//        }
//        self.dependencieEngine.register(for: GetIpdCredentialsUseCaseProtocol.self) { resolver in
//            return GetIpdCredentialsUseCase(dependenciesResolver: resolver)
//        }
    }
}

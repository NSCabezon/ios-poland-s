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

final class AppModifiers {
    private let dependencieEngine: DependenciesResolver & DependenciesInjector
    private lazy var depositModifiers: GlobalPosition.DepositModifier = {
        let depositModifier = DepositModifier(dependenciesResolver: self.dependencieEngine)
        return depositModifier
    }()
    private lazy var fundModifiers: GlobalPosition.FundModifier = {
        let fundModifier = FundModifier(dependenciesResolver: self.dependencieEngine)
        return fundModifier
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
//        self.dependencieEngine.register(for: AccountHomeActionModifier.self) { _ in
//            return self.accountHomeActionModifier
//        }
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
//        self.dependencieEngine.register(for: CardHomeActionModifier.self) { _ in
//            return self.cardHomeActionModifier
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
//        self.dependencieEngine.register(for: OtherOperativesModifierProtocol.self) { resolver in
//            return self.otherOperativesModifier
//        }
    }
}
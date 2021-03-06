import TransferOperatives
import CoreFoundationLib

struct SendMoneyDependencies {
    let legacyDependenciesInjector: DependenciesInjector
    
    func registerDependencies() {
        legacyDependenciesInjector.register(for: SendMoneyModifierProtocol.self) { resolver in
            return SendMoneyModifier(legacyDependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: PreSetupSendMoneyUseCaseProtocol.self) { resolver in
            return PreSetupSendMoneyUseCase(dependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: SendMoneyTransferTypeUseCaseProtocol.self) { resolver in
            return SendMoneyTransferTypeUseCase(dependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: SendMoneyTransferTypeUseCaseInputAdapterProtocol.self) { _ in
            return SendMoneyTransferTypeUseCaseInputAdapter()
        }
        legacyDependenciesInjector.register(for: IbanValidationSendMoneyUseCaseProtocol.self) { resolver in
            return IbanValidationSendMoneyUseCase(dependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: ValidateGenericSendMoneyUseCaseProtocol.self) { resolver in
            return PLValidateGenericSendMoneyUseCase(dependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: ValidateScheduledSendMoneyUseCaseProtocol.self) { resolver in
            return PLValidateGenericSendMoneyUseCase(dependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: SendMoneyDestinationUseCaseProtocol.self) { resolver in
            return PLSendMoneyDestinationUseCase(dependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: SendMoneyAmountUseCaseProtocol.self) { resolver in
            return PLSendMoneyAmountUseCase(dependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: SendMoneyConfirmationUseCaseProtocol.self) { resolver in
            return PLSendMoneyConfirmationUseCase(dependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: SendMoneyExchangeRatesUseCaseProtocol.self) { resolver in
            return PLSendMoneyExchangeRatesUseCase(dependenciesResolver: resolver)
        }
        legacyDependenciesInjector.register(for: SendMoneySwiftBranchesUseCaseProtocol.self) { resolver in
            return PLSendMoneySwiftBranchesUseCase(dependenciesResolver: resolver)
        }
    }
}

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
    }
}

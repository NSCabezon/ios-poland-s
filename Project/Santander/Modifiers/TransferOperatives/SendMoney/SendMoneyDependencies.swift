import TransferOperatives
import Commons

struct SendMoneyDependencies {
    let dependenciesEngine: DependenciesResolver & DependenciesInjector

    func registerDependencies() {
        self.dependenciesEngine.register(for: SendMoneyModifierProtocol.self) { _ in
            return SendMoneyModifier(dependenciesEngine: self.dependenciesEngine)
        }
        self.dependenciesEngine.register(for: PreSetupSendMoneyUseCaseProtocol.self) { resolver in
            return PreSetupSendMoneyUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: SendMoneyTransferTypeUseCaseProtocol.self) { resolver in
            return SendMoneyTransferTypeUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: SendMoneyTransferTypeUseCaseInputAdapterProtocol.self) { _ in
            return SendMoneyTransferTypeUseCaseInputAdapter()
        }
        self.dependenciesEngine.register(for: IbanValidationSendMoneyUseCaseProtocol.self) { resolver in
            return IbanValidationSendMoneyUseCase(dependenciesResolver: resolver)
        }
    }
}

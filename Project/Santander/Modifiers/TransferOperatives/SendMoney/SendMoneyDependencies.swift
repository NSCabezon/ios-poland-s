import TransferOperatives
import Commons

struct SendMoneyDependencies {
    let dependenciesEngine: DependenciesResolver & DependenciesInjector

    func registerDependencies() {
        self.dependenciesEngine.register(for: SendMoneyOperativeModifierProtocol.self) { resolver in
            return SendMoneyOperativeModifier(dependenciesEngine: self.dependenciesEngine)
        }
        self.dependenciesEngine.register(for: PreSetupSendMoneyUseCaseProtocol.self) { resolver in
            return PreSetupSendMoneyUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: SendMoneyTransferTypeUseCaseProtocol.self) { resolver in
            return SendMoneyTransferTypeUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: SendMoneyTransferTypeUseCaseInputAdapterProtocol.self) { resolver in
            return SendMoneyTransferTypeUseCaseInputAdapter()
        }
    }
}

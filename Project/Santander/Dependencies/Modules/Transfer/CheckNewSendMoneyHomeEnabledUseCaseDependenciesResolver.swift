import CoreFoundationLib

protocol CheckNewSendMoneyHomeEnabledUseCaseDependenciesResolver {
    func resolve() -> AppConfigRepositoryProtocol
    func resolve() -> CheckNewSendMoneyHomeEnabledUseCase
}

extension ModuleDependencies: CheckNewSendMoneyHomeEnabledUseCaseDependenciesResolver {
    func resolve() -> CheckNewSendMoneyHomeEnabledUseCase {
        return DefaultCheckNewSendMoneyHomeEnabledUseCase(dependencies: self)
    }
}

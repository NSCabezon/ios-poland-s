import SANPLLibrary
import CoreFoundationLib

protocol PLQuickBalanceGetSettingsUseCaseProtocol: UseCase<Void, GetQuickBalanceSettingsUseCaseOkOutput, StringErrorOutput> {}

final class PLQuickBalanceGetSettingsUseCase: UseCase<Void, GetQuickBalanceSettingsUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let managersProvider: PLManagersProviderProtocol

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }

    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetQuickBalanceSettingsUseCaseOkOutput, StringErrorOutput> {
        let result = try managersProvider.getQuickBalanceManager().getQuickBalanceSettings()
        switch result {
        case .success(let settings):
            return responseFor(settings: settings)
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }

    private func responseFor(settings: [PLGetQuickBalanceSettingsDTO]) -> UseCaseResponse<GetQuickBalanceSettingsUseCaseOkOutput, StringErrorOutput> {
        return .ok(
            GetQuickBalanceSettingsUseCaseOkOutput(settings: settings)
        )
    }
}

extension PLQuickBalanceGetSettingsUseCase: PLQuickBalanceGetSettingsUseCaseProtocol {}

struct GetQuickBalanceSettingsUseCaseOkOutput {
    let dto: [PLGetQuickBalanceSettingsDTO]

    init(settings: [PLGetQuickBalanceSettingsDTO]) {
        self.dto = settings
    }
}

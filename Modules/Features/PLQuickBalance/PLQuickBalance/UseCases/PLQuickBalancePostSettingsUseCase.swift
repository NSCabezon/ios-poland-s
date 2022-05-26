import SANPLLibrary
import CoreFoundationLib

protocol PLQuickBalancePostSettingsUseCaseProtocol: UseCase<PLQuickBalanceSettingsUseCaseInput, Void, StringErrorOutput> {}

class PLQuickBalancePostSettingsUseCase: UseCase<PLQuickBalanceSettingsUseCaseInput,
                                         Void,
                                         StringErrorOutput> {
    let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    override func executeUseCase(requestValues: PLQuickBalanceSettingsUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let accounts = requestValues.accounts?.compactMap({ account -> PLQuickBalanceConfirmParameterDTO? in
            guard let id = account.accountNo else { return nil }
            return PLQuickBalanceConfirmParameterDTO(accountNo: id, amount: account.amount)
        })

        let response = try managerProvider.getQuickBalanceManager().confirmQuickBalance(accounts: accounts)

        switch response {
        case .success(_):
            return .ok()
        case .failure(let error):
            return .error(StringErrorOutput(error.errorDescription))
        }
    }
}

extension PLQuickBalancePostSettingsUseCase: PLQuickBalancePostSettingsUseCaseProtocol {}

struct PLQuickBalanceAccount {
    let accountNo: String?
    let amount: Double?
}

struct PLQuickBalanceSettingsUseCaseInput {
    let accounts: [PLQuickBalanceAccount]?
}

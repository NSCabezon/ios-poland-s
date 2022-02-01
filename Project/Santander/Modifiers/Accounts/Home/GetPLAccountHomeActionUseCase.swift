import SANLegacyLibrary
import CoreFoundationLib
import Account
import SANPLLibrary

final class GetPLAccountHomeActionUseCase: UseCase<GetAccountHomeActionUseCaseInput, GetAccountHomeActionUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver

    private let externalTransfer: AccountActionType = .custome(identifier:                                                  "externalAccountTransfer",
                                                        accesibilityIdentifier: "externalAccountTransfer",
                                                        trackName: "externalAccountTransfer",
                                                        localizedKey: "accountOption_button_transfer",
                                                        icon: "icnSendMoney")
    
    private let blik: AccountActionType = .custome(identifier: "blik",
                                                   accesibilityIdentifier: "blik",
                                                   trackName: "blik",
                                                   localizedKey: "pt_frequentOperative_button_blik",
                                                   icon: "icnBlik",
                                                   renderingMode: .alwaysOriginal)
    
    private let savingsGoals: AccountActionType = .custome(identifier: PLAccountOtherOperativesIdentifier.savingGoals.rawValue,
                                                           accesibilityIdentifier: "savingsGoals",
                                                           trackName: "savingsGoals",
                                                           localizedKey: "accountOption_button_savingGoals",
                                                           icon: "icnSavingGoals")
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: GetAccountHomeActionUseCaseInput) throws -> UseCaseResponse<GetAccountHomeActionUseCaseOkOutput, StringErrorOutput> {
        guard let entityCode = requestValues.account.entityCode else {
            return .ok(GetAccountHomeActionUseCaseOkOutput(actions: [.transfer, self.blik, .accountDetail, self.savingsGoals]))
        }
        if isAccountFromSantander(entityCode) {
            return .ok(GetAccountHomeActionUseCaseOkOutput(actions: [.transfer, self.blik, .accountDetail, self.savingsGoals]))
        } else {
//            return .ok(GetAccountHomeActionUseCaseOkOutput(actions: [.transfer, self.externalTransfer, self.blik, .accountDetail, self.savingsGoals]))
            return .ok(GetAccountHomeActionUseCaseOkOutput(actions: [.transfer, self.blik, .accountDetail, self.savingsGoals]))
        }
    }
}

private extension GetPLAccountHomeActionUseCase {
    func isAccountFromSantander(_ entityCode: String) -> Bool {
        let accountDescriptorRepository: AccountDescriptorRepositoryProtocol = self.dependenciesResolver.resolve(for: AccountDescriptorRepositoryProtocol.self)
        guard let accountGroupEntities = accountDescriptorRepository.getAccountDescriptor()?.accountGroupEntities else { return false }

        return accountGroupEntities.contains(where: {$0.entityCode == entityCode})
    }
}

extension GetPLAccountHomeActionUseCase: GetAccountHomeActionUseCaseProtocol {}

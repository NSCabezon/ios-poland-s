import SANLegacyLibrary
import DomainCommon
import Models
import Commons
import Account

final class GetPLAccountHomeActionUseCase: UseCase<GetAccountHomeActionUseCaseInput, GetAccountHomeActionUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    private let blik: AccountActionType = .custome(identifier: "blik",
                                                   accesibilityIdentifier: "blik",
                                                   trackName: "blik",
                                                   localizedKey: "pt_frequentOperative_button_blik",
                                                   icon: "icnBlik",
                                                   renderingMode: .alwaysOriginal)
    
    private let savingsGoals: AccountActionType = .custome(identifier: PLAccountOtherOperativesIdentifier.saving_goals.rawValue,
                                                           accesibilityIdentifier: "savingsGoals",
                                                           trackName: "savingsGoals",
                                                           localizedKey: "accountOption_button_savingGoals",
                                                           icon: "icnSavingGoals")
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: GetAccountHomeActionUseCaseInput) throws -> UseCaseResponse<GetAccountHomeActionUseCaseOkOutput, StringErrorOutput> {
        return .ok(GetAccountHomeActionUseCaseOkOutput(actions: [.transfer, self.blik, .accountDetail, self.savingsGoals]))
    }
}

extension GetPLAccountHomeActionUseCase: GetAccountHomeActionUseCaseProtocol {}

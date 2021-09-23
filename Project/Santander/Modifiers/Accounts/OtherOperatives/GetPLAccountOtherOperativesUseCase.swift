import SANLegacyLibrary
import DomainCommon
import Models
import Commons
import Account

final class GetPLAccountOtherOperativesActionUseCase: UseCase<GetAccountOtherOperativesActionUseCaseInput, GetAccountOtherOperativesActionUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
 
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: GetAccountOtherOperativesActionUseCaseInput) throws -> UseCaseResponse<GetAccountOtherOperativesActionUseCaseOkOutput, StringErrorOutput> {
        return .ok(GetAccountOtherOperativesActionUseCaseOkOutput(everyDayOperatives: [], otherOperativeActions: [], queriesActions: [], contractActions: [], officeArrangementActions: []))
    }
}

extension GetPLAccountOtherOperativesActionUseCase: GetAccountOtherOperativesActionUseCaseProtocol {}

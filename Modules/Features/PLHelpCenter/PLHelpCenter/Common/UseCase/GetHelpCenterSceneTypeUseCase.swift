import Foundation
import DomainCommon
import Commons
import SANPLLibrary

protocol GetHelpCenterSceneTypeUseCaseProtocol: UseCase<Void, GetHelpCenterSceneTypeUseCaseOkOutput, StringErrorOutput> {}

final class GetHelpCenterSceneTypeUseCase: UseCase<Void, GetHelpCenterSceneTypeUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    private lazy var plManagersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetHelpCenterSceneTypeUseCaseOkOutput, StringErrorOutput> {
        let loginManager = plManagersProvider.getLoginManager()
        
        let helpCenterSceneType: HelpCenterSceneType
        if let authCredentials = try? loginManager.getAuthCredentials(),
           authCredentials.accessTokenCredentials != nil {
            helpCenterSceneType = .dashboard
        } else {
            helpCenterSceneType = .contact
        }
        
        return .ok(GetHelpCenterSceneTypeUseCaseOkOutput(sceneType: helpCenterSceneType))
    }
}

extension GetHelpCenterSceneTypeUseCase: GetHelpCenterSceneTypeUseCaseProtocol {}

struct GetHelpCenterSceneTypeUseCaseOkOutput {
    let sceneType: HelpCenterSceneType
}

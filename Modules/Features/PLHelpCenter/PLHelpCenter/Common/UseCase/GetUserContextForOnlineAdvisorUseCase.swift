import Foundation
import DomainCommon
import Commons
import Models
import SANPLLibrary

protocol GetUserContextForOnlineAdvisorUseCaseProtocol: UseCase<GetUserContextForOnlineAdvisorUseCaseOkInput, GetUserContextForOnlineAdvisorUseCaseOkOutput, StringErrorOutput> {}

final class GetUserContextForOnlineAdvisorUseCase: UseCase<GetUserContextForOnlineAdvisorUseCaseOkInput, GetUserContextForOnlineAdvisorUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    private lazy var plManagersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    private lazy var helpCenterManager = plManagersProvider.getHelpCenterManager()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: GetUserContextForOnlineAdvisorUseCaseOkInput) throws -> UseCaseResponse<GetUserContextForOnlineAdvisorUseCaseOkOutput, StringErrorOutput> {
        // Parameters have been transformed according to informations from MOBILE-7883
        let parameters = OnlineAdvisorUserContextParameters(
            baseAddress: requestValues.baseAddress,
            msgTypeName: requestValues.entryType,
            productName: requestValues.mediumType,
            messageSubject: requestValues.subjectID
        )
        
        switch getCurrentUserLoginStatus() {
        case .notLogged:
            return try getUserContextForOnlineAdvisorBeforeLogin(parameters)
        case .loggedIn:
            return try getUserContextForOnlineAdvisor(parameters)
        }
    }
    private func getUserContextForOnlineAdvisorBeforeLogin(_ parameters: OnlineAdvisorUserContextParameters) throws -> UseCaseResponse<GetUserContextForOnlineAdvisorUseCaseOkOutput, StringErrorOutput> {
        try handleResult(helpCenterManager.getUserContextForOnlineAdvisorBeforeLogin(parameters))
    }
    
    private func getUserContextForOnlineAdvisor(_ parameters: OnlineAdvisorUserContextParameters) throws -> UseCaseResponse<GetUserContextForOnlineAdvisorUseCaseOkOutput, StringErrorOutput> {
        try handleResult(helpCenterManager.getUserContextForOnlineAdvisor(parameters))
    }
    
    private func handleResult(_ result: Result<OnlineAdvisorUserContextDTO, NetworkProviderError>) throws -> UseCaseResponse<GetUserContextForOnlineAdvisorUseCaseOkOutput, StringErrorOutput> {
        switch result {
        case let .success(onlineAdvisorUserContext):
            return .ok(GetUserContextForOnlineAdvisorUseCaseOkOutput(pdata: onlineAdvisorUserContext.pdata))
        case let .failure(error):
            return .error(.init(error.localizedDescription))
        }
    }
    
    private func getCurrentUserLoginStatus() -> UserLoginStatus {
        let loginManager = plManagersProvider.getLoginManager()
        if let authCredentials = try? loginManager.getAuthCredentials(),
           authCredentials.accessTokenCredentials != nil {
            return .loggedIn
        } else {
            return .notLogged
        }
    }
}

extension GetUserContextForOnlineAdvisorUseCase: GetUserContextForOnlineAdvisorUseCaseProtocol {}

private enum UserLoginStatus {
    case loggedIn
    case notLogged
}

struct GetUserContextForOnlineAdvisorUseCaseOkInput {
    let entryType: String
    let mediumType: String
    let subjectID: String
    let baseAddress: String
}

struct GetUserContextForOnlineAdvisorUseCaseOkOutput {
    let pdata: String // Contains values needed by the OnlineAdvisor module
}

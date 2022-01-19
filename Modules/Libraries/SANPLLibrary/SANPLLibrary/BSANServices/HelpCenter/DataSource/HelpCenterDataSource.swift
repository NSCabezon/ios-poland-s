import Foundation

protocol HelpCenterDataSourceProtocol {
    func getUserContextForOnlineAdvisor(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError>
    func getUserContextForOnlineAdvisorBeforeLogin(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError>
}

private extension HelpCenterDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class HelpCenterDataSource {
    private enum HelpCenterServiceType: String {
        case getUserContextForOnlineAdvisor = "/auth/virtualadvisor/context"
        case getUserContextForOnlineAdvisorBeforeLogin = "/auth/virtualadvisor/context/before-login"
    }
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    private var headers: [String: String] = [:]
    private var queryParams: [String: Any]? = nil
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
}

extension HelpCenterDataSource: HelpCenterDataSourceProtocol {
    func getUserContextForOnlineAdvisor(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError> {
        guard let body = parameters.getJsonData(), let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        
        let serviceName = HelpCenterServiceType.getUserContextForOnlineAdvisor.rawValue
        let absoluteUrl = baseUrl + basePath
        let result: Result<OnlineAdvisorUserContextDTO, NetworkProviderError> =
            self.networkProvider.request(
                GetOnlineAdvisorUserContextRequest(
                    serviceName: serviceName,
                    serviceUrl: absoluteUrl,
                    method: .post,
                    body: body,
                    jsonBody: parameters,
                    headers: headers,
                    queryParams: queryParams,
                    contentType: .json,
                    localServiceName: .globalPosition,
                    authorization: .oauth
                )
            )
        return result
    }
    
    func getUserContextForOnlineAdvisorBeforeLogin(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError> {
            guard let body = parameters.getJsonData(), let baseUrl = self.getBaseUrl() else {
                return .failure(NetworkProviderError.other)
            }
            
            let serviceName = HelpCenterServiceType.getUserContextForOnlineAdvisorBeforeLogin.rawValue
            let absoluteUrl = baseUrl + basePath
            let result: Result<OnlineAdvisorUserContextDTO, NetworkProviderError> =
                self.networkProvider.request(
                    GetOnlineAdvisorUserContextRequest(
                        serviceName: serviceName,
                        serviceUrl: absoluteUrl,
                        method: .post,
                        body: body,
                        jsonBody: parameters,
                        headers: headers,
                        queryParams: queryParams,
                        contentType: .json,
                        localServiceName: .globalPosition,
                        authorization: .none
                    )
                )
            return result
    }
}

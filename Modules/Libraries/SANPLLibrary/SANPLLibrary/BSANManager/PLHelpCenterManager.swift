import Foundation

public protocol PLHelpCenterManagerProtocol {
    func getOnlineAdvisorConfig() throws -> Result<OnlineAdvisorDTO, NetworkProviderError>
    func getHelpQuestionsConfig() throws -> Result<HelpQuestionsDTO, NetworkProviderError>
    func getUserContextForOnlineAdvisor(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError>
    func getUserContextForOnlineAdvisorBeforeLogin(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError>
}

public final class PLHelpCenterManager {
    private let dataSource: HelpCenterDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.dataSource = HelpCenterDataSource(
            networkProvider: networkProvider,
            dataProvider: bsanDataProvider
        )
        self.bsanDataProvider = bsanDataProvider
    }
}

extension PLHelpCenterManager: PLHelpCenterManagerProtocol {
    
    public func getOnlineAdvisorConfig() throws -> Result<OnlineAdvisorDTO, NetworkProviderError> {
        if let helpCenterInfo = bsanDataProvider.getHelpCenterInfo(),
           let onlineAdvisor = helpCenterInfo.onlineAdvisor,
           let lastStoreDate = helpCenterInfo.onlineAdvisorStoreDate,
           let checkInterval = Double(onlineAdvisor.checkInterval),
           Date() <= lastStoreDate.addingMinutes(checkInterval) {
            return .success(onlineAdvisor)
        }
        
        let result = try dataSource.getOnlineAdvisorConfig()
        switch result {
        case .success(let config):
            bsanDataProvider.store(helpCenterOnlineAdvisor: config)
            return .success(config)
        case .failure(let error):
            if let onlineAdvisor = bsanDataProvider.getHelpCenterInfo()?.onlineAdvisor {
                return .success(onlineAdvisor)
            } else {
                return .failure(error)
            }
        }
    }
    
    public func getHelpQuestionsConfig() throws -> Result<HelpQuestionsDTO, NetworkProviderError> {
        if let helpQuestionsInfo = bsanDataProvider.getHelpQuestionsInfo(),
           let helpQuestions = helpQuestionsInfo.helpQuestions,
           let lastStoreDate = helpQuestionsInfo.helpQuestionsStoreDate,
           Date() <= lastStoreDate.addingMinutes(Double(helpQuestions.checkInterval)) {
            return .success(helpQuestions)
        }
        
        let result = try dataSource.getHelpQuestionsConfig()
        switch result {
        case .success(let config):
            bsanDataProvider.store(helpCenterHelpQuestions: config)
            return .success(config)
        case .failure(let error):
            if let helpQuestions = bsanDataProvider.getHelpQuestionsInfo()?.helpQuestions {
                return .success(helpQuestions)
            } else {
                return .failure(error)
            }
        }
    }
    
    public func getUserContextForOnlineAdvisor(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError> {
        return try dataSource.getUserContextForOnlineAdvisor(parameters)
    }
    
    public func getUserContextForOnlineAdvisorBeforeLogin(_ parameters: OnlineAdvisorUserContextParameters) throws -> Result<OnlineAdvisorUserContextDTO, NetworkProviderError> {
        return try dataSource.getUserContextForOnlineAdvisorBeforeLogin(parameters)
    }
}

private extension Date {
    
    func addingMinutes(_ minutes: Double) -> Self {
        return addingTimeInterval(minutes * 60)
    }
}

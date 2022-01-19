import Foundation

public protocol PLHelpCenterManagerProtocol {
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

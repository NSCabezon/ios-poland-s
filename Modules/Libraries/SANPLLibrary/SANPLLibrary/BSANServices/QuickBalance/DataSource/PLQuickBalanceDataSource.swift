protocol PLQuickBalanceDataSourceProtocol {
    func getQuickBalanceLastTransaction() throws -> Result<PLQuickBalanceDTO, NetworkProviderError>
    func getQuickBalanceSettings() throws -> Result<[PLGetQuickBalanceSettingsDTO], NetworkProviderError>
    func confirmQuickBalance(accounts: [PLQuickBalanceConfirmParameterDTO]?) throws -> Result<Void, NetworkProviderError>
}

final class PLQuickBalanceDataSource: PLQuickBalanceDataSourceProtocol {
    private enum serviceType: String {
        case getQuickBalance = "quick-balance"
        case getQuickBalanceAccounts = "quick-balance/accounts"

    }
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private var headers: [String: String] = [:]
    private let basePath = "/api/v2/"

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }

    func getQuickBalanceLastTransaction() throws -> Result<PLQuickBalanceDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let serviceName = "\(serviceType.getQuickBalance.rawValue)"
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<PLQuickBalanceDTO, NetworkProviderError> = networkProvider.request(PLQuickBalanceGetRequest(serviceName: serviceName,
                                                                                                                     serviceUrl: absoluteUrl,
                                                                                                                     method: .get,
                                                                                                                     headers: self.headers,
                                                                                                                     queryParams: nil,
                                                                                                                     contentType: nil,
                                                                                                                     localServiceName: .quickBalance)
        )
        return result
    }


    func getQuickBalanceSettings() throws -> Result<[PLGetQuickBalanceSettingsDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let serviceName = "\(serviceType.getQuickBalanceAccounts.rawValue)"
        let absoluteUrl = baseUrl + self.basePath
        let request = PLQuickBalanceSettingsGetRequest(serviceName: serviceName,
                                                       serviceUrl: absoluteUrl,
                                                       method: .get,
                                                       headers: self.headers,
                                                       queryParams: nil,
                                                       contentType: nil,
                                                       localServiceName: .quickBalanceSettings)
        return networkProvider.request(request)
    }

    func confirmQuickBalance(accounts: [PLQuickBalanceConfirmParameterDTO]?) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        let serviceName = "\(serviceType.getQuickBalanceAccounts.rawValue)"
        let absoluteUrl = baseUrl + self.basePath
        let request = PLQuickBalanceConfirmPostRequest(serviceName: serviceName,
                                                       serviceUrl: absoluteUrl,
                                                       method: .post,
                                                       jsonBody: accounts,
                                                       bodyEncoding: .body,
                                                       headers: self.headers,
                                                       queryParams: nil,
                                                       contentType: .json,
                                                       localServiceName: .confirmQuickBalance)
        return networkProvider.request(request)
    }
}

private extension PLQuickBalanceDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

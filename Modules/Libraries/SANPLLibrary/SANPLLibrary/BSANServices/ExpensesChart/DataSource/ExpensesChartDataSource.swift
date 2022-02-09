//
//  ExpensesChartDataSource.swift
//  SANPLLibrary
//

protocol ExpensesChartDataSourceProtocol {
    func getExpenses() -> Result<ExpensesChartDTO, NetworkProviderError>
}

private extension ExpensesChartDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class ExpensesChartDataSource {
    private enum ExpensesChartServiceType: String {
        case getExpenses = "/pfm/turnovers/monthly"
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

extension ExpensesChartDataSource: ExpensesChartDataSourceProtocol {

    func getExpenses() -> Result<ExpensesChartDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }

        self.headers = ["plnCurrency" : "true"]
        let absoluteUrl = baseUrl + self.basePath
        let serviceName = ExpensesChartServiceType.getExpenses.rawValue
        let result: Result<ExpensesChartDTO, NetworkProviderError> = self.networkProvider.request(ExpensesChartRequest(serviceName: serviceName,
                                                                                                                       serviceUrl: absoluteUrl,
                                                                                                                       method: .get,
                                                                                                                       headers: self.headers,
                                                                                                                       queryParams: self.queryParams,
                                                                                                                       contentType: .json,
                                                                                                                       localServiceName: .expensesChart))
        return result
    }
}

private struct ExpensesChartRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding? = .none
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: Encodable? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}

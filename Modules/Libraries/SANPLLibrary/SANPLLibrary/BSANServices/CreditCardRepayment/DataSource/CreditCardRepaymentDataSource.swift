import Foundation

protocol CreditCardRepaymentDataSourceProtocol {
    func getAccountsForDebit() throws -> Result<[CCRAccountDTO], NetworkProviderError>
    func getAccountsForCredit() throws -> Result<[CCRAccountDTO], NetworkProviderError>
    func sendRepayment(_ parameters: AcceptDomesticTransactionParameters) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError>
}

private extension CreditCardRepaymentDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class CreditCardRepaymentDataSource {
    private enum CreditCardRepaymentServiceType: String {
        case accountsForDebit = "/accounts/for-debit/1"
        case accountsForCredit = "/accounts/for-credit/1"
        case globalPositionCards = "/gps"
        case send = "/transactions/domestic/create/accepted"
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

extension CreditCardRepaymentDataSource: CreditCardRepaymentDataSourceProtocol {
    
    func getAccountsForCredit() throws -> Result<[CCRAccountDTO], NetworkProviderError> {
        guard let baseUrl = getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        
        let serviceName = CreditCardRepaymentServiceType.accountsForCredit.rawValue
        let absoluteUrl = baseUrl + basePath
        let result: Result<[CCRAccountDTO], NetworkProviderError> =
            self.networkProvider.request(
                GetCCRAccountsRequest(
                    serviceName: serviceName,
                    serviceUrl: absoluteUrl,
                    method: .get,
                    headers: headers,
                    queryParams: queryParams,
                    contentType: .urlEncoded,
                    localServiceName: .globalPosition,
                    authorization: .oauth
                )
            )
        return result
    }

    
    func getAccountsForDebit() throws -> Result<[CCRAccountDTO], NetworkProviderError> {
        guard let baseUrl = getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        
        let serviceName = CreditCardRepaymentServiceType.accountsForDebit.rawValue
        let absoluteUrl = baseUrl + basePath
        let result: Result<[CCRAccountDTO], NetworkProviderError> =
            self.networkProvider.request(
                GetCCRAccountsRequest(
                    serviceName: serviceName,
                    serviceUrl: absoluteUrl,
                    method: .get,
                    headers: headers,
                    queryParams: queryParams,
                    contentType: .urlEncoded,
                    localServiceName: .globalPosition,
                    authorization: .oauth
                )
            )
        return result
    }
    
    func sendRepayment(_ parameters: AcceptDomesticTransactionParameters) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        guard let body = parameters.getJsonData(),
              let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        
        let serviceName = CreditCardRepaymentServiceType.send.rawValue
        let absoluteUrl = baseUrl + basePath
        let result: Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> =
            self.networkProvider.request(
                AcceptDomesticTransferRequest(
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
}

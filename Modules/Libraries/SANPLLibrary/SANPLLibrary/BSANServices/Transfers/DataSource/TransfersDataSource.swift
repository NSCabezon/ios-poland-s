//
//  TransfersDataSource.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary

protocol TransfersDataSourceProtocol {
    func getAccountsForDebit() throws -> Result<[AccountForDebitDTO], NetworkProviderError>
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<PayeeListDTO, NetworkProviderError>
    func getRecentRecipients() throws -> Result<RecentRecipientsDTO, NetworkProviderError>
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<IBANValidationDTO, NetworkProviderError>
    func checkFinalFee(_ parameters: CheckFinalFeeParameters, destinationAccount: String) throws -> Result<CheckFinalFeeDTO, NetworkProviderError>
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionDTO, NetworkProviderError>
}

private extension TransfersDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class TransfersDataSource {
    private enum TransferServiceType: String {
        case accountForDebit = "/accounts/for-debit"
        case payees = "/payees/account"
        case recentRecipients = "/transactions/recent-recipients"
        case ibanValidation = "/accounts/"
        case checkFinalFee = "/transactions/domestic/final-fee/"
        case checkTransactionAvailability = "/payhubpl-prodef/api/instant_payments/accounts/"
    }
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    private var headers: [String: String] = [:]

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
}

extension TransfersDataSource: TransfersDataSourceProtocol {
    
    func getAccountsForDebit() throws -> Result<[AccountForDebitDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = TransferServiceType.accountForDebit.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<[AccountForDebitDTO], NetworkProviderError> = self.networkProvider.request(
            AccountRequest(
                serviceName: serviceName,
                serviceUrl: absoluteUrl,
                method: .get,
                headers: self.headers,
                queryParams: nil,
                contentType: .urlEncoded,
                localServiceName: .accountsForDebit
            )
        )
        return result
    }
    
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<PayeeListDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let queryParameters = try? parameters.asDictionary() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName: TransferServiceType = .payees
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<PayeeListDTO, NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName.rawValue,
                                                                                                           serviceUrl: absoluteUrl,
                                                                                                           method: .get,
                                                                                                           headers: self.headers,
                                                                                                           queryParams: queryParameters,
                                                                                                           contentType: .queryString,
                                                                                                           localServiceName: .getPayees)
        )
        return result
    }
    
    func getRecentRecipients() throws -> Result<RecentRecipientsDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName: TransferServiceType = .recentRecipients
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<RecentRecipientsDTO, NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName.rawValue,
                                                                                                           serviceUrl: absoluteUrl,
                                                                                                           method: .get,
                                                                                                           headers: self.headers,
                                                                                                           contentType: .urlEncoded,
                                                                                                           localServiceName: .recentRecipients)
        )
        return result
    }
    
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<IBANValidationDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName: String = TransferServiceType.ibanValidation.rawValue + "\(parameters.accountNumber)" + "/branch/" + "\(parameters.branchId)"
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<IBANValidationDTO, NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName,
                                                                                                           serviceUrl: absoluteUrl,
                                                                                                           method: .get,
                                                                                                           headers: self.headers,
                                                                                                           queryParams: nil,
                                                                                                           contentType: .queryString,
                                                                                                           localServiceName: .ibanValidation)
        )
        return result
    }
    
    func checkFinalFee(_ parameters: CheckFinalFeeParameters, destinationAccount: String) throws -> Result<CheckFinalFeeDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let queryParameters = try? parameters.asDictionary() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = TransferServiceType.checkFinalFee.rawValue + destinationAccount
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<CheckFinalFeeDTO, NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: queryParameters,
                                                                                                                contentType: .urlEncoded,
                                                                                                                localServiceName: .checkFinalFee)
        )
        return result
    }
    
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let queryParameters = try? parameters.asDictionary() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName:String = TransferServiceType.checkTransactionAvailability.rawValue + accountReceiver + "/check_transaction_availability"
        let absoluteUrl = baseUrl.replacingOccurrences(of: "/oneapp", with: "")
        let result: Result<CheckTransactionDTO, NetworkProviderError> = self.networkProvider.request(AccountRequest(serviceName: serviceName,
                                                                                                                    serviceUrl: absoluteUrl,
                                                                                                                    method: .get,
                                                                                                                    headers: self.headers,
                                                                                                                    queryParams: queryParameters,
                                                                                                                    contentType: .queryString,
                                                                                                                    localServiceName: .checkTransaction)
        )
        return result
    }
}

private struct AccountRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: WithholdingParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: WithholdingParameters? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         contentType: NetworkProviderContentType,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.jsonBody = jsonBody
        self.method = method
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.bodyEncoding = bodyEncoding
        self.contentType = contentType
        self.localServiceName = localServiceName
    }
}

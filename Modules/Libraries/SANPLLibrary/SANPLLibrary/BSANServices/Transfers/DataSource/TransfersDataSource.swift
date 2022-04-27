//
//  TransfersDataSource.swift
//  SANPLLibrary
//

import Foundation
import SANLegacyLibrary
import CoreDomain

protocol TransfersDataSourceProtocol {
    func getAccountsForDebit() throws -> Result<[AccountForDebitDTO], NetworkProviderError>
    func getAccountsForCredit() throws -> Result<[AccountForCreditDTO], NetworkProviderError>
    func getAccountsForDebitSwitch() throws -> Result<[AccountForDebitDTO], NetworkProviderError>
    func getAccountsForCreditSwitch(_ accountType: String) throws -> Result<[AccountForCreditDTO], NetworkProviderError>
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[PayeeDTO], NetworkProviderError>
    func getRecentRecipients() throws -> Result<RecentRecipientsDTO, NetworkProviderError>
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<IBANValidationDTO, NetworkProviderError>
    func checkFinalFee(_ parameters: CheckFinalFeeParameters, destinationAccount: String) throws -> Result<CheckFinalFeeDTO, NetworkProviderError>
    func sendConfirmation(_ parameters: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, NetworkProviderError>
    func getChallenge(_ parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeDTO, NetworkProviderError>
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionDTO, NetworkProviderError>
    func notifyDevice(_ parameters: NotifyDeviceParameters) throws -> Result<AuthorizationIdDTO, NetworkProviderError>
    func getExchangeRates() throws -> Result<ExchangeRatesDTO, NetworkProviderError>
}

private extension TransfersDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class TransfersDataSource {
    private enum TransferServiceType: String {
        case accountForDebit = "/accounts/for-debit"
        case accountForCredit = "/accounts/for-credit/1"
        case accountForCreditSwitch = "/accounts/for-credit/61"
        case payees = "/payees/account/all"
        case recentRecipients = "/transactions/recent-recipients"
        case ibanValidation = "/accounts/"
        case checkFinalFee = "/transactions/domestic/final-fee/"
        case confirmationTransfer = "/transactions/domestic/create/accepted"
        case challenge = "/transactions/domestic/prepare"
        case checkTransactionAvailability = "/payhubpl-prodef/api/instant_payments/accounts/"
        case notifyDevice = "/auth/devices/mobile-authorization/notify-device/transactions"
        case exchangeRates = "/exrates"
    }
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    private let version2 = "/v2"
    private var headers: [String: String] = [:]

    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
}

extension TransfersDataSource: TransfersDataSourceProtocol {
    
    func getChallenge(_ parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else { return .failure(NetworkProviderError.other) }
        let absoluteUrl = baseUrl + self.basePath
        let serviceName = TransferServiceType.challenge.rawValue + "?option=CHALLENGE"
        let result: Result<SendMoneyChallengeDTO, NetworkProviderError> = self.networkProvider.request(ChallengeRequest(serviceName: serviceName,
                                                                                                                      serviceUrl: absoluteUrl,
                                                                                                                      method: .post,
                                                                                                                      jsonBody: parameters,
                                                                                                                      headers: headers,
                                                                                                                      bodyEncoding: .body,
                                                                                                                      contentType: .json,
                                                                                                                      localServiceName: .challenge))
        return result
    }

    
    func getAccountsForDebit() throws -> Result<[AccountForDebitDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = TransferServiceType.accountForDebit.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<[AccountForDebitDTO], NetworkProviderError> = self.networkProvider.request(
            TransferRequest(
                serviceName: serviceName,
                serviceUrl: absoluteUrl,
                method: .get,
                headers: self.headers,
                queryParams: nil,
                contentType: nil,
                localServiceName: .accountsForDebit
            )
        )
        return result
    }
    
    func getAccountsForDebitSwitch() throws -> Result<[AccountForDebitDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let queryParams = ["context": "SWITCH"]
        let serviceName = TransferServiceType.accountForDebit.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<[AccountForDebitDTO], NetworkProviderError> = self.networkProvider.request(
            TransferRequest(
                serviceName: serviceName,
                serviceUrl: absoluteUrl,
                method: .get,
                headers: self.headers,
                queryParams: queryParams,
                contentType: nil,
                localServiceName: .accountsForDebit
            )
        )
        return result
    }
    
    func getAccountsForCredit() throws -> Result<[AccountForCreditDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = TransferServiceType.accountForCredit.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<[AccountForCreditDTO], NetworkProviderError> = self.networkProvider.request(
            TransferRequest(
                serviceName: serviceName,
                serviceUrl: absoluteUrl,
                method: .get,
                headers: self.headers,
                queryParams: nil,
                contentType: nil,
                localServiceName: .accountsForCredit
            )
        )
        return result
    }
    
    func getAccountsForCreditSwitch(_ accountType: String) throws -> Result<[AccountForCreditDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let queryParams = ["context": "SWITCH", "srcAccountType": accountType]
        let serviceName = TransferServiceType.accountForCreditSwitch.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<[AccountForCreditDTO], NetworkProviderError> = self.networkProvider.request(
            TransferRequest(
                serviceName: serviceName,
                serviceUrl: absoluteUrl,
                method: .get,
                headers: self.headers,
                queryParams: queryParams,
                contentType: nil,
                localServiceName: .accountsForCredit
            )
        )
        return result
    }
    
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[PayeeDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let queryParameters = try? parameters.asDictionary() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName: TransferServiceType = .payees
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<[PayeeDTO], NetworkProviderError> = self.networkProvider.request(TransferRequest(serviceName: serviceName.rawValue,
                                                                                                           serviceUrl: absoluteUrl,
                                                                                                           method: .get,
                                                                                                           headers: self.headers,
                                                                                                           queryParams: queryParameters,
                                                                                                           contentType: nil,
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
        let result: Result<RecentRecipientsDTO, NetworkProviderError> = self.networkProvider.request(TransferRequest(serviceName: serviceName.rawValue,
                                                                                                           serviceUrl: absoluteUrl,
                                                                                                           method: .get,
                                                                                                           headers: self.headers,
                                                                                                           contentType: nil,
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
        let result: Result<IBANValidationDTO, NetworkProviderError> = self.networkProvider.request(TransferRequest(serviceName: serviceName,
                                                                                                           serviceUrl: absoluteUrl,
                                                                                                           method: .get,
                                                                                                           headers: self.headers,
                                                                                                           queryParams: nil,
                                                                                                           contentType: nil,
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
        let result: Result<CheckFinalFeeDTO, NetworkProviderError> = self.networkProvider.request(TransferRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                queryParams: queryParameters,
                                                                                                                contentType: nil,
                                                                                                                localServiceName: .checkFinalFee)
        )
        return result
    }
    
    func sendConfirmation(_ parameters: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, NetworkProviderError> {
        guard let body = parameters.getJsonData(),
              let baseUrl = self.getBaseUrl()
        else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName: TransferServiceType = .confirmationTransfer
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<ConfirmationTransferDTO, NetworkProviderError> = self.networkProvider.request(TransferRequest(serviceName: serviceName.rawValue,
                                                                                                                         serviceUrl: absoluteUrl,
                                                                                                                         method: .post,
                                                                                                                         body: body,
                                                                                                                         jsonBody: parameters,
                                                                                                                         headers: self.headers,
                                                                                                                         bodyEncoding: .body,
                                                                                                                         contentType: .json,
                                                                                                                         localServiceName: .confirmationTransfer,
                                                                                                                         authorization: .twoFactorOperation(
                                                                                                                            transactionParameters: parameters.transactionParameters
                                                                                                                         )))
        return result
    }
    
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(),
              let queryParameters = try? parameters.asDictionary() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName:String = TransferServiceType.checkTransactionAvailability.rawValue + accountReceiver + "/check_transaction_availability"
        let absoluteUrl = baseUrl.replacingOccurrences(of: "/oneapp", with: "")
        let result: Result<CheckTransactionDTO, NetworkProviderError> = self.networkProvider.request(TransferRequest(serviceName: serviceName,
                                                                                                                    serviceUrl: absoluteUrl,
                                                                                                                    method: .get,
                                                                                                                    headers: self.headers,
                                                                                                                    queryParams: queryParameters,
                                                                                                                    contentType: nil,
                                                                                                                    localServiceName: .checkTransaction)
        )
        return result
    }
    
    func notifyDevice(_ parameters: NotifyDeviceParameters) throws -> Result<AuthorizationIdDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = TransferServiceType.notifyDevice.rawValue
        let absoluteUrl = baseUrl + self.basePath
        let result: Result<AuthorizationIdDTO, NetworkProviderError> = self.networkProvider.request(NotifiyDeviceRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .post,
                                                                                                                jsonBody: parameters,
                                                                                                                headers: self.headers,
                                                                                                                bodyEncoding: .body,
                                                                                                                contentType: .json,
                                                                                                                localServiceName: .notifiyDevice)
        )
        return result
    }
    
    func getExchangeRates() throws -> Result<ExchangeRatesDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceName = TransferServiceType.exchangeRates.rawValue
        let absoluteUrl = baseUrl + self.basePath + self.version2
        let result: Result<ExchangeRatesDTO, NetworkProviderError> = self.networkProvider.request(ExchangeRatesRequest(serviceName: serviceName,
                                                                                                                serviceUrl: absoluteUrl,
                                                                                                                method: .get,
                                                                                                                headers: self.headers,
                                                                                                                localServiceName: .exchangeRates))
        return result
    }
}

private struct TransferRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: GenericSendMoneyConfirmationInput?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: GenericSendMoneyConfirmationInput? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = .oauth) {
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
        self.authorization = authorization
    }
}

private struct ChallengeRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: GenericSendMoneyConfirmationInput?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: GenericSendMoneyConfirmationInput? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         contentType: NetworkProviderContentType?,
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

private struct NotifiyDeviceRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: NotifyDeviceParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth
    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: NotifyDeviceParameters? = nil,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         contentType: NetworkProviderContentType?,
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

private struct ExchangeRatesRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: NotifyDeviceParameters? = nil
    let formData: Data? = nil
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType? = nil
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth
    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         headers: [String: String]?,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.headers = headers
        self.bodyEncoding = bodyEncoding
        self.localServiceName = localServiceName
    }
}

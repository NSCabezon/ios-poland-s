
protocol BLIKDataSourceProtocol {
    func getPSPTicket() throws -> Result<GetPSPDTO, NetworkProviderError>
    func getWalletsActive() throws -> Result<[GetWalletsActiveDTO], NetworkProviderError>
    func getTrnToConf() throws -> Result<GetTrnToConfDTO, NetworkProviderError>
    func getActiveCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError>
    func getArchivedCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError>
    func getWalletParams() throws -> Result <WalletParamsDTO, NetworkProviderError>
    func cancelCheque(chequeId: Int) throws -> Result<Void, NetworkProviderError>
    func setChequePin(request: SetChequeBlikPinParameters) throws -> Result<Void, NetworkProviderError>
    func createCheque(request: CreateChequeRequestDTO) throws -> Result<CreateChequeResponseDTO, NetworkProviderError>
    func cancelTransaction(request: CancelBLIKTransactionRequestDTO, trnId: Int) throws -> Result<Void, NetworkProviderError>
    func getPinPublicKey() throws -> Result<PubKeyDTO, NetworkProviderError>
    func getAccounts() throws -> Result<[BlikCustomerAccountDTO], NetworkProviderError>
    func acceptTransaction(trnId: Int, trnDate: String) throws -> Result<Void, NetworkProviderError>
    func phoneVerification(aliases: [String]) throws -> Result<PhoneVerificationDTO, NetworkProviderError>
    func p2pAlias(msisdn: String) throws -> Result<P2pAliasDTO, NetworkProviderError>
    func setPSPAliasLabel(_ parameters: SetPSPAliasLabelParameters) throws -> Result<Void, NetworkProviderError>
    func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<RegisterPhoneNumberResponseDTO, NetworkProviderError>
    func setTransactionLimits(_ request: TransactionLimitRequestDTO) throws -> Result<Void, NetworkProviderError>
    func getAliases() throws -> Result<[BlikAliasDTO], NetworkProviderError>
    func deleteAlias(_ request: DeleteBlikAliasParameters) throws -> Result<Void, NetworkProviderError>
    func acceptTransfer(
        _ parameters: AcceptDomesticTransactionParameters,
        transactionParameters: TransactionParameters?
    ) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError>
    func registerAlias(_ parameters: RegisterBlikAliasParameters) throws -> Result<Void, NetworkProviderError>
    func getTransactions() throws -> Result<BlikTransactionDTO, NetworkProviderError>
}

private extension BLIKDataSource {
    func getBaseUrl() -> String? {
        try? dataProvider.getEnvironment().urlBase
    }
    
    func blikAuthBaseUrl() -> String? {
        try? dataProvider.getEnvironment().blikAuthBaseUrl
    }
}

class BLIKDataSource: BLIKDataSourceProtocol {
    
    private enum BlikServiceType: String {
        case activeEwallets = "/e-wallet/ewallets/active"
        case pspTickets = "/e-wallet/psp-ticket"
        case transactionToConfirm = "/transactions"
        case activeCheques = "/e-wallet/cheques/active"
        case archivedCheques = "/e-wallet/cheques/archived"
        case walletParams = "/e-wallet/params"
        case cheques = "/e-wallet/cheques"
        case chequesPin = "/e-wallet/cheques/pin"
        case publicKey = "/pub_key/KEY_BLIK_CHEQUE_PIN"
        case accounts = "/customer/accounts"
        case phoneVerification = "/e-wallet/phone-verification"
        case p2pAlias = "/e-wallet/p2p-alias"
        case pspAliasLabel = "/e-wallet/psp-alias-label"
        case pspAlias = "/e-wallet/psp-alias"
        case transactionLimit = "/e-wallet/limits"
        case aliases = "/oc/aliases/active"
        case registerAlias = "/oc/register-alias"
        case unregisterAlias = "/oc/unregister-alias"
        case acceptTransfer = "/domestic/create/accepted"
    }
    
    private let blikPath = "/api/blik"
    private let authPath = "/api/as"
    private let transactionsPath = "/api/transactions"
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
        
    enum Error: Swift.Error {
        case noBaseURL
    }
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
    
    func getWalletsActive() throws -> Result<[GetWalletsActiveDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.activeEwallets.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }
    
    func getPSPTicket() throws -> Result<GetPSPDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.pspTickets.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }
    
    func getTrnToConf() throws -> Result<GetTrnToConfDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.transactionToConfirm.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }

    func getActiveCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.activeCheques.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }
    
    func getArchivedCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.archivedCheques.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }
    
    func getWalletParams() throws -> Result <WalletParamsDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.walletParams.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }
    
    func cancelCheque(chequeId: Int) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.cheques.rawValue + "/\(chequeId)"
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .delete)
        )
    }
    
    func setChequePin(request: SetChequeBlikPinParameters) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(request) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.chequesPin.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }
    
    func createCheque(request: CreateChequeRequestDTO) throws -> Result<CreateChequeResponseDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(request) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.cheques.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }
    
    func cancelTransaction(request: CancelBLIKTransactionRequestDTO, trnId: Int) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(request) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.transactionToConfirm.rawValue + "/\(trnId)/confirm"
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }
    
    func acceptTransaction(trnId: Int, trnDate: String) throws -> Result<Void, NetworkProviderError> {
        let request = AcceptBLIKTransactionRequestDTO(transactionDate: trnDate)
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(request) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.transactionToConfirm.rawValue + "/\(trnId)/confirm"
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }

    func getPinPublicKey() throws -> Result<PubKeyDTO, NetworkProviderError> {
        guard let authBaseUrl = self.blikAuthBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = authBaseUrl + authPath
        let serviceName = BlikServiceType.publicKey.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }
    
    func getAccounts() throws -> Result<[BlikCustomerAccountDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.accounts.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }
    
    func phoneVerification(aliases: [String]) throws -> Result<PhoneVerificationDTO, NetworkProviderError> {
        let request = PhoneVerificationDTO(aliases: aliases)
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(request) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.phoneVerification.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }
    
    func p2pAlias(msisdn: String) throws -> Result<P2pAliasDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.p2pAlias.rawValue
        let queryParams: [String: Any] = ["msisdn": msisdn]
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get,
                        queryParams: queryParams,
                        contentType: .queryString)
        )
    }

    func setPSPAliasLabel(_ parameters: SetPSPAliasLabelParameters) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(parameters) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.pspAliasLabel.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }
    
    func unregisterPhoneNumber() throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.pspAlias.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .delete)
        )
    }
    
    func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<RegisterPhoneNumberResponseDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(request) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.pspAlias.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }
    
    func setTransactionLimits(_ request: TransactionLimitRequestDTO) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(request) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.transactionLimit.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }
    
    func getAliases() throws -> Result<[BlikAliasDTO], NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.aliases.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }
    
    func deleteAlias(_ request: DeleteBlikAliasParameters) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(request) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.unregisterAlias.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }

    func acceptTransfer(
        _ parameters: AcceptDomesticTransactionParameters,
        transactionParameters: TransactionParameters?
    ) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + transactionsPath
        let serviceName = BlikServiceType.acceptTransfer.rawValue
        return networkProvider.request(
            AcceptDomesticTransferRequest(serviceName: serviceName,
                                          serviceUrl: serviceUrl,
                                          method: .post,
                                          jsonBody: parameters,
                                          authorization: .twoFactorOperation(
                                            transactionParameters: transactionParameters
                                          )
                                        
            )
        )
    }
    
    func registerAlias(_ parameters: RegisterBlikAliasParameters) throws -> Result<Void, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl(), let data = try? JSONEncoder().encode(parameters) else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.registerAlias.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .post,
                        request: data,
                        bodyEncoding: .form)
        )
    }
    
    func getTransactions() throws -> Result<BlikTransactionDTO, NetworkProviderError> {
        guard let baseUrl = self.getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        let serviceUrl = baseUrl + blikPath
        let serviceName = BlikServiceType.aliases.rawValue
        return networkProvider.request(
            BlikRequest(serviceName: serviceName,
                        serviceUrl: serviceUrl,
                        method: .get)
        )
    }
}

private struct BlikRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: AuthenticateInitParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         request: Data? = nil,
         queryParams: [String: Any]? = nil,
         jsonBody: AuthenticateInitParameters? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         headers: [String: String]? = [:],
         contentType: NetworkProviderContentType = .json,
         localServiceName: PLLocalServiceName = .authenticateInit,
         authorization: NetworkProviderRequestAuthorization? = .oauth) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = request
        self.queryParams = queryParams
        self.jsonBody = jsonBody
        self.bodyEncoding = bodyEncoding
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}

import CoreDomain
import Commons
import SANPLLibrary
import CoreFoundationLib
import SANLegacyLibrary

struct MockHostProvider: PLHostProviderProtocol {
    var environmentDefault: BSANPLEnvironmentDTO {
        .init(name: "default", blikAuthBaseUrl: "", urlBase: "https://micrositeoneapp2.santanderbankpolska.pl", clientId: "123")
    }
    
    func getEnvironments() -> [BSANPLEnvironmentDTO] {
        [environmentDefault]
    }
}

struct MockManager: PLManagersProviderProtocol {
    
    let resolver: DependenciesResolver

    func getHelpCenterManager() -> PLHelpCenterManagerProtocol {
        fatalError()
    }
    
    func getLoanScheduleManager() -> PLLoanScheduleManagerProtocol {
        fatalError()
    }
    
    func getAccountsManager() -> PLAccountManagerProtocol {
        MockAccountManager()
    }

    func getCreditCardRepaymentManager() -> PLCreditCardRepaymentManagerProtocol {
        fatalError()
    }
    
    func getTrustedDeviceManager() -> PLTrustedDeviceManager {
        fatalError()
    }
    
    func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol {
        fatalError()
    }
    
    func getCardsManager() -> PLCardsManagerProtocol {
        fatalError()
    }
    
    func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol {
        fatalError()
    }
    
    func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol {
        fatalError()
    }
    
    func getCustomerManager() -> PLCustomerManagerProtocol {
        fatalError()
    }
    
    func getLoginManager() -> PLLoginManagerProtocol {
        MockLoginManeger()
    }
    
    func getBLIKManager() -> PLBLIKManagerProtocol {
        fatalError()
    }
    
    func getNotificationManager() -> PLNotificationManagerProtocol {
        fatalError()
    }
    
    func getTransferManager() -> PLTransfersManagerProtocol {
        MockTransferManager()
    }
    
    func getPhoneTopUpManager() -> PLPhoneTopUpManagerProtocol {
        fatalError()
    }
}

struct MockAccountManager: PLAccountManagerProtocol {
    
    func changeAlias(accountDTO: SANLegacyLibrary.AccountDTO, newAlias: String) throws -> Result<AccountChangeAliasDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getDetails(accountNumber: String, parameters: AccountDetailsParameters) throws -> Result<SANPLLibrary.AccountDetailDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getSwiftBranches(accountNumber: String) throws -> Result<SwiftBranchesDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getWithholdingList(accountNumber: String) throws -> Result<SANPLLibrary.WithholdingListDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getAccountsForDebit(transactionType: Int) throws -> Result<[DebitAccountDTO], NetworkProviderError> {
        let jsonData = """
        [{
            "number": "12123412341234123412341234",
            "id": "1",
            "currencyCode": "PLN",
            "name": {
                "source": "Konto Jakie Chcesz",
                "description": "Konto Jakie Chcesz",
                "userDefined": ""
            },
            "type": "PERSONAL",
            "balance": {
                "value": 2000,
                "currencyCode": "PLN"
            },
            "availableFunds": {
                "value": 2000,
                "currencyCode": "PLN"
            },
            "systemId": 1,
            "defaultForPayments": false,
            "accountDetails": {
                "accountType": 1,
                "sequenceNumber": 1
            }
        },
        {
            "number": "34345634563456345634563456",
            "id": "2",
            "currencyCode": "PLN",
            "name": {
                "source": "Konto Jakie Chcesz",
                "description": "Konto Jakie Chcesz",
                "userDefined": ""
            },
            "type": "PERSONAL",
            "balance": {
                "value": 5000,
                "currencyCode": "PLN"
            },
            "availableFunds": {
                "value": 5000,
                "currencyCode": "PLN"
            },
            "systemId": 1,
            "defaultForPayments": false,
            "accountDetails": {
                "accountType": 1,
                "sequenceNumber": 1
            }
        }]
        """.data(using: .utf8)!
            
        let response = try! JSONDecoder().decode([DebitAccountDTO].self, from: jsonData)
        return .success(response)
    }
    
    func loadAccountTransactions(parameters: AccountTransactionsParameters?) throws -> Result<AccountTransactionsDTO, NetworkProviderError> {
        fatalError()
    }
}

struct MockTransferManager: PLTransfersManagerProtocol {
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[SANPLLibrary.PayeeDTO], NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<CheckInternalAccountRepresentable, NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func getRecentRecipients() throws -> Result<[TransferRepresentable], NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func checkFinalFee(_ parameters: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func sendConfirmation(_ parameters: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, NetworkProviderError> {
        let jsonData = """
                {
                    "customerAddressData": {
                        "customerName": "Jan Nowak",
                        "city": "Testowo",
                        "street": "Testowa 3",
                        "zipCode": "12-345",
                        "baseAddress": "Testowa 3, Testowo"
                    },
                    "debitAmountData": {
                        "currency": "PLN",
                        "amount": 50,
                        "currencyRate": null,
                        "currencyUnit": null
                    },
                    "creditAmountData": {
                        "currency": "PLN",
                        "amount": 50,
                        "currencyRate": null,
                        "currencyUnit": null
                    },
                    "debitAccountData": {
                        "accountType": 1,
                        "accountSequenceNumber": 123,
                        "branchId": "",
                        "accountNo": "12123412341234123412341234",
                        "accountName": "Konto Jakie Chesz"
                    },
                    "creditAccountData": {
                        "accountType": 1,
                        "accountSequenceNumber": 123,
                        "branchId": "",
                        "accountNo": "12123412341234123412341234",
                        "accountName": "Konto Jakie Chesz"
                    },
                    "transactionAmountData": {
                        "baseAmount": 50
                    },
                    "title": "Darowizna na fundację Santander",
                    "type": "INTERNAL",
                    "valueDate": "2022-01-01",
                    "sendApplicationId": null,
                    "timestamp": null,
                    "options": null,
                    "ownerCifNumber": null,
                    "transactionSide": null,
                    "noFixedRate": null,
                    "customerRef": null,
                    "transferType": null,
                    "key": null,
                    "signHistoryData": null,
                    "state": null,
                    "sendError": null,
                    "postingId": null,
                    "acceptanceTime": "2022-01-01"
                }
        """.data(using: .utf8)!
            
        let response = try! JSONDecoder().decode(ConfirmationTransferDTO.self, from: jsonData)
        return .success(response)
    }
    
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionAvailabilityRepresentable, NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError> {
        .failure(.noConnection)
    }
}

struct MockStringLoader: StringLoader {
    func updateCurrentLanguage(language: Language) {
        fatalError()
    }
    
    func getCurrentLanguage() -> Language {
        return Language.createFromType(languageType: .polish, isPb: false)
    }
    
    func getString(_ key: String) -> LocalizedStylableText {
        fatalError()
    }
    
    func getString(_ key: String, _ stringPlaceholders: [StringPlaceholder]) -> LocalizedStylableText {
        fatalError()
    }
    
    func getQuantityString(_ key: String, _ count: Int, _ stringPlaceholders: [StringPlaceholder]) -> LocalizedStylableText {
        fatalError()
    }
    
    func getQuantityString(_ key: String, _ count: Double, _ stringPlaceholders: [StringPlaceholder]) -> LocalizedStylableText {
        fatalError()
    }
    
    func getWsErrorString(_ key: String) -> LocalizedStylableText {
        fatalError()
    }
    
    func getWsErrorIfPresent(_ key: String) -> LocalizedStylableText? {
        fatalError()
    }
    
    func getWsErrorWithNumber(_ key: String, _ phone: String) -> LocalizedStylableText {
        fatalError()
    }
}

struct MockLoginManeger: PLLoginManagerProtocol {
    
    func getLoginInfo() throws -> Result<LoginInfoDTO, NetworkProviderError> {
        fatalError()
    }
    
    func setDemoModeIfNeeded(for user: String) -> Bool {
        fatalError()
    }
    
    func isDemoUser(userId: String) -> Bool {
        fatalError()
    }
    
    func doLogin(_ parameters: LoginParameters) throws -> Result<LoginDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getPubKey() throws -> Result<PubKeyDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getPersistedPubKey() throws -> PubKeyDTO {
        fatalError()
    }
    
    func doAuthenticateInit(_ parameters: AuthenticateInitParameters) throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        fatalError()
    }
    
    func doAuthenticate(_ parameters: AuthenticateParameters) throws -> Result<AuthenticateDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getAuthCredentials() throws -> SANPLLibrary.AuthCredentials {
        AuthCredentials(login: "123456789",
                        userId: 1,
                        userCif: 1,
                        companyContext: false,
                        accessTokenCredentials: nil,
                        trustedDeviceTokenCredentials: nil)
    }
    
    func getAppInfo() -> AppInfo? {
        fatalError()
    }
    
    func setAppInfo(_ appInfo: AppInfo) {
        fatalError()
    }
    
    func doLogout() throws -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> {
        fatalError()
    }
}

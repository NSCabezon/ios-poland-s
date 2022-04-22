import CoreDomain
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import OpenCombine

struct MockHostProvider: PLHostProviderProtocol {
    var environmentDefault: BSANPLEnvironmentDTO {
        .init(name: "default", blikAuthBaseUrl: "", urlBase: "https://micrositeoneapp2.santanderbankpolska.pl", clientId: "123")
    }
    
    func getEnvironments() -> [BSANPLEnvironmentDTO] {
        [environmentDefault]
    }
}

struct MockManager: PLManagersProviderProtocol {
    func getHistoryManager() -> PLHistoryManagerProtocol {
        fatalError()
    }
    
    func getExpensesChartManager() -> PLExpensesChartManagerProtocol {
        fatalError()
    }
    
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
    
    func getDepositsManager() -> PLDepositManagerProtocol {
        fatalError()
    }
    
    func getFundsManager() -> PLFundManagerProtocol {
        fatalError()
    }
    
    func getAuthorizationProcessorManager() -> PLAuthorizationProcessorManagerProtocol {
        PLAuthorizationProcessorManagerMock()
    }
    
    func getSplitPaymentManager() -> PLSplitPaymentManagerProtocol {
        fatalError()
    }
}

struct MockAccountManager: PLAccountManagerProtocol {
    func getExternalPopular(accountType: Int) throws -> Result<[PopularAccountDTO], NetworkProviderError> {
        .success(PopularAccountMock.popularAccounts)
    }
    
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
    func getAccountsForCredit() throws -> Result<[AccountRepresentable], NetworkProviderError> {
        fatalError()
    }
    
    func getExchangeRates() throws -> Result<ExchangeRatesDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[SANPLLibrary.PayeeDTO], NetworkProviderError> {
        let jsonData = """
         [
         {
         "payeeId": {
            "contractType":"ACCOUNT",
            "id":"1000"
         },
         "alias":"ZUS",
         "stamp":953319531,
         "account": {
            "accountType": {
                "code":90
            },
            "currencyCode":"PLN",
            "accountNo":"PL02600000020260006109165886",
            "payeeName":"ZUS",
            "branchInfo": {
                "branchCode":"60000002"
            },
            "transferType":"ELIXIR"
         },
         "recipientType":"DOMESTIC_BENEFICIARY"
         }
         ]
         """.data(using: .utf8)!
        let response = try! JSONDecoder().decode([SANPLLibrary.PayeeDTO].self, from: jsonData)
        return .success(response)
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
    
    func getDepositsManager() -> PLDepositManagerProtocol {
        fatalError()
    }
    
    func getFundsManager() -> PLFundManagerProtocol {
        fatalError()
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

final class PLTransfersRepositoryMock: PLTransfersRepository {
    func sendConfirmation(input: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, Error> {
        fatalError()
    }
    
    func getAccountsForCredit() throws -> Result<[AccountRepresentable], Error> {
        fatalError()
    }
    
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], Error> {
        fatalError()
    }
    
    func getExchangeRates() -> AnyPublisher<[ExchangeRateRepresentable], Error> {
        fatalError()
    }
    
    func loadAllUsualTransfers() -> AnyPublisher<[PayeeRepresentable], Error> {
        fatalError()
    }
    
    func noSepaPayeeDetail(of alias: String, recipientType: String) -> AnyPublisher<NoSepaPayeeDetailRepresentable, Error> {
        fatalError()
    }
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError> {
        .success(SendMoneyChallengeMock())
    }
    
    func getAccountForDebit() throws -> Result<[AccountRepresentable], Error> {
        fatalError()
    }
    
    func checkTransactionAvailability(input: CheckTransactionAvailabilityInput) throws -> Result<CheckTransactionAvailabilityRepresentable, Error> {
        fatalError()
    }
    
    func getFinalFee(input: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], Error> {
        fatalError()
    }
    
    func checkInternalAccount(input: CheckInternalAccountInput) throws -> Result<CheckInternalAccountRepresentable, Error> {
        fatalError()
    }
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, Error> {
        .success(SendMoneyChallengeMock())
    }
    
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError> {
        .success(AuthorizationIdMock())
    }
    
    func transferType(originAccount: AccountRepresentable, selectedCountry: String, selectedCurrerncy: String) throws -> Result<TransfersType, Error> {
        fatalError()
    }
    
    func validateGenericTransfer(originAccount: AccountRepresentable, nationalTransferInput: SendMoneyGenericTransferInput) throws -> Result<ValidateAccountTransferRepresentable, Error> {
        fatalError()
    }
    
    func validateDeferredTransfer(originAcount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
        fatalError()
    }
    
    func validatePeriodicTransfer(originAcount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
        fatalError()
    }
    
    func validateGenericTransferOTP(originAccount: AccountRepresentable, nationalTransferInput: NationalTransferInputRepresentable, signature: SignatureRepresentable) throws -> Result<OTPValidationRepresentable, Error> {
        fatalError()
    }
    
    func validatePeriodicTransferOTP(signature: SignatureRepresentable, dataToken: String) throws -> Result<OTPValidationRepresentable, Error> {
        fatalError()
    }
    
    func validateDeferredTransferOTP(signature: SignatureRepresentable, dataToken: String) throws -> Result<OTPValidationRepresentable, Error> {
        fatalError()
    }
    
    func confirmGenericTransfer(originAccount: AccountRepresentable, nationalTransferInput: SendMoneyGenericTransferInput, otpValidation: OTPValidationRepresentable?, otpCode: String?) throws -> Result<TransferConfirmAccountRepresentable, Error> {
        fatalError()
    }
    
    func confirmDeferredTransfer(originAccount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput, otpValidation: OTPValidationRepresentable, otpCode: String) throws -> Result<Void, Error> {
        fatalError()
    }
    
    func confirmPeriodicTransfer(originAccount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput, otpValidation: OTPValidationRepresentable, otpCode: String) throws -> Result<Void, Error> {
        fatalError()
    }
}

struct SendMoneyChallengeMock: SendMoneyChallengeRepresentable {
    var challengeRepresentable: String? {
        "97216838"
    }
}

struct AuthorizationIdMock: AuthorizationIdRepresentable {
    var authorizationId: Int? {
        587
    }
}

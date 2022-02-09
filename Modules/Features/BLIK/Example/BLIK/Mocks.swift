import UI
import CoreFoundationLib
import SANPLLibrary
import PLCryptography

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
        resolver.resolve()
    }
    
    func getLoanScheduleManager() -> PLLoanScheduleManagerProtocol {
        fatalError()
    }
    
    func getAccountsManager() -> PLAccountManagerProtocol {
        MockAccountManeger()
    }

    func getCreditCardRepaymentManager() -> PLCreditCardRepaymentManagerProtocol {
        resolver.resolve()
    }
    
    func getTrustedDeviceManager() -> PLTrustedDeviceManager {
        resolver.resolve()
    }
    
    func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol {
        resolver.resolve()
    }
    
    func getCardsManager() -> PLCardsManagerProtocol {
        resolver.resolve()
    }
    
    func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol {
        fatalError()
    }
    
    func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol {
        resolver.resolve()
    }
    
    func getCustomerManager() -> PLCustomerManagerProtocol {
        MockCustomerManager()
    }
    
    func getLoginManager() -> PLLoginManagerProtocol {
        MockLoginManeger()
    }
    
    func getBLIKManager() -> PLBLIKManagerProtocol {
        MockBLIKManager()
    }
    
    func getNotificationManager() -> PLNotificationManagerProtocol {
        fatalError()
    }
    
    func getTransferManager() -> PLTransfersManagerProtocol {
        fatalError()
    }
    
    func getPhoneTopUpManager() -> PLPhoneTopUpManagerProtocol {
        fatalError()
    }
}

struct MockBLIKManager: PLBLIKManagerProtocol {
    
    func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<Void, NetworkProviderError> {
        .failure(.noConnection)
    }
  
    func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<RegisterPhoneNumberResponseDTO, NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func setTransactionLimits(_ request: TransactionLimitRequestDTO) throws -> Result<Void, NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func getAliases() throws -> Result<[BlikAliasDTO], NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func deleteAlias(_ request: DeleteBlikAliasParameters) throws -> Result<Void, NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func registerAlias(_ request: RegisterBlikAliasParameters) throws -> Result<Void, NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func p2pAlias(msisdn: String) throws -> Result<P2pAliasDTO, NetworkProviderError> {
        let jsonData = """
                {
                "dstAccNo": "98 9876 9876 9876 9876 9876 9876",
                "isDstAccInternal": false
                }
        """.data(using: .utf8)!
            
        let response = try! JSONDecoder().decode(P2pAliasDTO.self, from: jsonData)
        return .success(response)
    }
    
    func phoneVerification(aliases: [String]) throws -> Result<PhoneVerificationDTO, NetworkProviderError> {
        let jsonData = """
                {
                "aliases": ["\("123456789".hash)"]
                }
        """.data(using: .utf8)!
            
        let response = try! JSONDecoder().decode(PhoneVerificationDTO.self, from: jsonData)
        return .success(response)
    }
    
    func setPSPAliasLabel(_ label: String) throws -> Result<Void, NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func getAccounts() throws -> Result<[DebitAccountDTO], NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func acceptTransaction(trnId: Int, trnDate: String) throws -> Result<Void, NetworkProviderError> {
        .success(Void())
    }
    
    func getPinPublicKey() throws -> Result<PubKeyDTO, NetworkProviderError> {
        .failure(NetworkProviderError.noConnection)
    }
    
    func cancelTransaction(request: CancelBLIKTransactionRequestDTO, trnId: Int) throws -> Result<Void, NetworkProviderError> {
        .success(Void())
    }
    
    func createCheque(request: CreateChequeRequestDTO) throws -> Result<CreateChequeResponseDTO, NetworkProviderError> {
        let jsonData = """
                {
                "authCodeId": "id",
                "ticket": "ticket",
                "ticketTime": "1626854788",
                }
        """.data(using: .utf8)!
            
        let response = try! JSONDecoder().decode(CreateChequeResponseDTO.self, from: jsonData)
        return .success(response)
    }
    
    func setChequePin(request: SetChequeBlikPinParameters) throws -> Result<Void, NetworkProviderError> {
        .success(Void())
    }
  
    
    func getTrnToConf() throws -> Result<GetTrnToConfDTO, NetworkProviderError> {
        let jsonData = """
                {
                "trnId": 192246,
                "title": "Przelew",
                "date": "2021-06-28",
                "time": "2021-07-05T14:17:00.331+02:00",
                "transferType": "BLIK_WEB_PURCHASES",
                "amount":
                    {
                        "amount": 14.99
                    },
                "merchant":
                    {
                        "shortName": "Sklep",
                        "address": "Miastowa 8",
                        "city": "Kraków"
                    },
                "aliases":
                    {
                        "proposal": [],
                        "auth": null
                    }
                }
        """.data(using: .utf8)!
        
//        let errorJsonData = """
//                {
//                "errorCode1": 11,
//                "errorCode2": 728,
//                "message": "String",
//                }
//        """.data(using: .utf8)!


        let response = try! JSONDecoder().decode(GetTrnToConfDTO.self, from: jsonData)
//        let error = NetworkProviderResponseError(code: 510, data: errorJsonData, headerFields: nil, error: nil)
        
        
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            semaphore.signal()
        }
        semaphore.wait()
        return .success(response)
//        return .failure(.error(error))
    }

    func cancelCheque(chequeId: Int) throws -> Result<Void, NetworkProviderError> {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            semaphore.signal()
        }
        semaphore.wait()
        return .success(Void())
    }
    
    func getActiveCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError> {
        let jsonData = """
            [
              {
                "authCodeId": 42,
                "ticketData": {
                  "ticket": "Ticket",
                  "amount": 1220,
                  "name": "Czek",
                  "currency": "PLN",
                  "createTime": "2021.06.22'T'09:22:13",
                  "cancelTime": "2021.06.25'T'09:22:13",
                  "executionTime": "2021.06.20'T'09:22:13",
                  "expiryTime": "2021.06.30'T'09:22:13",
                  "status": "ACTIVE"
                },
                "transaction": {
                  "amount": 0,
                  "status": "NEW"
                }
              }
            ]
        """.data(using: .utf8)!
        let response = try! JSONDecoder().decode([BlikChequeDTO].self, from: jsonData)
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            semaphore.signal()
        }
        semaphore.wait()
        return .success(response)
    }
    
    func getArchivedCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError> {
        let jsonData = """
            [
              {
                "authCodeId": 42,
                "ticketData": {
                  "ticket": "Ticket",
                  "amount": 1220,
                  "name": "Czek",
                  "currency": "PLN",
                  "createTime": "2021.06.22'T'09:22:13",
                  "cancelTime": "2021.06.25'T'09:22:13",
                  "executionTime": "2021.06.20'T'09:22:13",
                  "expiryTime": "2021.06.30'T'09:22:13",
                  "status": "EXPIRED"
                },
                "transaction": {
                  "amount": 0,
                  "status": "NEW"
                }
              }
            ]
        """.data(using: .utf8)!
        let response = try! JSONDecoder().decode([BlikChequeDTO].self, from: jsonData)
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            semaphore.signal()
        }
        semaphore.wait()
        return .success(response)
    }
    
    func getWalletParams() throws -> Result<WalletParamsDTO, NetworkProviderError> {
        let jsonData = """
            {
              "singleLimitMax": 1000,
              "singleLimitMin": 0,
              "shopSingleLimitMax": 1000,
              "cycleLimitMax": 1000,
              "cycleLimitMin": 0,
              "shopCycleLimitMax": 1000,
              "noPinLimitMax": 1000,
              "noConfLimitMax": 1000,
              "maxChequeAmount": 20,
              "maxActiveCheques": 50
            }
        """.data(using: .utf8)!
        let response = try! JSONDecoder().decode(WalletParamsDTO.self, from: jsonData)

        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            semaphore.signal()
        }
        semaphore.wait()
        return .success(response)
    }
    
    func getPSPTicket() throws -> Result<GetPSPDTO, NetworkProviderError> {
        let random6digits = arc4random_uniform(900000) + 100000
        let jsonData = """
            {
              "authCodeId": 0,
              "ticket": "\(random6digits)",
              "ticketTime": 120
            }
        """.data(using: .utf8)!
        let response = try! JSONDecoder().decode(GetPSPDTO.self, from: jsonData)
        
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            semaphore.signal()
        }
        semaphore.wait()
        
        return .success(response)
    }
    
    func getWalletsActive() throws -> Result<[GetWalletsActiveDTO], NetworkProviderError> {
        let jsonData = """
            [
              {
                "ewId": 0,
                "chequePinStatus": "NOT_SET",
                "noPinTrnVisible": true,
                "alias": {
                    "label": "label",
                    "type": "EMPTY",
                    "isSynced": true
                },
                "accounts": {
                    "srcAccName": "name",
                    "srcAccShortName": "name",
                    "srcAccNo": "srcAccNo"
                },
                "limits": {
                    "noPinLimit": 1000.0,
                    "noConfLimit": 10000.0,
                    "shopLimits": {
                        "trnLimit": 10.0,
                        "cycleLimit": 100.0,
                        "cycleLimitRemaining": 10.0
                    },
                    "cashLimits": {
                        "trnLimit": 10.0,
                        "cycleLimit": 100.0,
                        "cycleLimitRemaining": 10.0
                    }
                }
              }
            ]
        """.data(using: .utf8)!

        let response = try! JSONDecoder().decode([GetWalletsActiveDTO].self, from: jsonData)
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            semaphore.signal()
        }
        semaphore.wait()
        return .success(response)
    }
    
    func unregisterPhoneNumber() throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func acceptTransfer(_ parameters: AcceptDomesticTransactionParameters, transactionParameters: TransactionParameters?) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        let jsonData = """
                {
                    "title": "String",
                    "type": "BLIK_P2P_TRANSACTION",
                    "state": "ACCEPTED",
                    "debitAmountData": {
                        "currency": "PLN",
                        "amount": 50
                    },
                    "debitAccountData": {
                        "accountType": 1,
                        "accountSequenceNumber": 1,
                        "accountNo": "12 1234 1234 1234 1234 1234 1234",
                        "accountName": "Konto Jakie Chcesz"
                    },
                    "creditAccountData": {
                        "accountType": 2,
                        "accountSequenceNumber": 2,
                        "accountNo": "98 9876 9876 9876 9876 9876 9876",
                        "accountName": "Konto Jakie Chcesz"
                    },
                    "dstPhoneNo": "123456789",
                    "valueDate": "13.12.2021"
                }
        """.data(using: .utf8)!
            
        let response = try! JSONDecoder().decode(AcceptDomesticTransferSummaryDTO.self, from: jsonData)
        return .success(response)
    }
    
    func setPSPAliasLabel(_ parameters: SetPSPAliasLabelParameters) throws -> Result<Void, NetworkProviderError> {
        .failure(.noConnection)
    }
    
    func getTransactions() throws -> Result<BlikTransactionDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getAccounts() throws -> Result<[BlikCustomerAccountDTO], NetworkProviderError> {
        fatalError()
    }
}

struct MockAccountManeger: PLAccountManagerProtocol {
    func getDetails(accountNumber: String, parameters: AccountDetailsParameters) throws -> Result<AccountDetailDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getSwiftBranches(accountNumber: String) throws -> Result<SwiftBranchesDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getWithholdingList(accountNumber: String) throws -> Result<WithholdingListDTO, NetworkProviderError> {
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

struct MockLoginManeger: PLLoginManagerProtocol {
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
    
    func getAuthCredentials() throws -> AuthCredentials {
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

struct MockCustomerManager: PLCustomerManagerProtocol {
    func getIndividual() throws -> Result<CustomerDTO, NetworkProviderError> {
        let jsonData = """
                {
                "contactData": {
                    "phoneNo": {
                        "prefix": "48",
                        "number": "123456789",
                    },
                    "email": "jannowak@mail.pl",
                },
                "address": {
                    "name": "Jan Kowalski",
                    "city": "Testowo",
                    "street": "Testowa",
                    "propertyNo": "55",
                    "zip": "12-345",
                    "countryCode": "123",
                    "voivodship": "123"
                },
                "correspondenceAddress": {
                    "name": "Jan Kowalski",
                    "city": "Testowo",
                    "street": "Testowa",
                    "propertyNo": "55",
                    "zip": "12-345",
                    "countryCode": "123",
                    "voivodship": "123"
                },
                "marketingSegment": "",
                "cif": 123456,
                "firstName": "Jan",
                "secondName": "Andrzej",
                "lastName": "Kowalski",
                "dateOfBirth": "01.01.1970",
                "pesel": "70010112345",
                "citizenship": ""
                }
        """.data(using: .utf8)!
            
        let response = try! JSONDecoder().decode(CustomerDTO.self, from: jsonData)
        return .success(response)
    }
}

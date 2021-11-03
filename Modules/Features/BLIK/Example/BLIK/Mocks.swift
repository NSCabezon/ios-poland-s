import UI
import Models
import Commons
import DataRepository
import SANPLLibrary

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
        resolver.resolve()
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
        fatalError()
    }
    
    func getLoginManager() -> PLLoginManagerProtocol {
        resolver.resolve()
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
}

struct MockBLIKManager: PLBLIKManagerProtocol {
  
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
        .failure(.noConnection)
    }
    
    func phoneVerification(aliases: [String]) throws -> Result<PhoneVerificationDTO, NetworkProviderError> {
        .failure(.noConnection)
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
              "ticket": \(random6digits),
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

    func acceptTransfer(_ parameters: AcceptDomesticTransactionParameters) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        .failure(.noConnection)
    }
}

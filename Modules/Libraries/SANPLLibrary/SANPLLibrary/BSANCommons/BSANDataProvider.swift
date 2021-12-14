//
//  BSANDataProvider.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import CoreFoundationLib
import SANLegacyLibrary

public enum BSANDatabaseKey : String {
    case TrustedDeviceHeaders
    case TrustedDeviceInfo
    case TrustedDeviceUserKeys
    case DeviceId
}

public class BSANDataProvider {
    
    public var isTrustedDevice: Bool {
        return getTrustedDeviceHeaders() != nil
    }
    
    private var dataRepository: DataRepository

    public init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }
    
    // MARK: - App Info
    public func storeAppInfo(_ appInfo: AppInfo) {
        objc_sync_enter(dataRepository)
        dataRepository.store(appInfo, .createPersistentPolicy())
        objc_sync_exit(dataRepository)
    }
    
    public func getAppInfo() -> AppInfo? {
        return dataRepository.get(AppInfo.self, .createPersistentPolicy())
    }
    
    // MARK: - Enviroment
    public func storeEnviroment(_ enviroment: BSANPLEnvironmentDTO) {
        objc_sync_enter(dataRepository)
        dataRepository.store(enviroment)
        objc_sync_exit(dataRepository)
    }
    
    public func getEnvironment() throws -> BSANPLEnvironmentDTO {
        if let bsanEnvironmentDTO = dataRepository.get(BSANPLEnvironmentDTO.self) {
            return bsanEnvironmentDTO
        }
        throw BSANIllegalStateException("BSANEnvironment is nil in DataRepository")
    }
    
    // MARK: - Auth Credentials
    public func storeAuthCredentials(_ authCredentials: AuthCredentials) {
        objc_sync_enter(self.dataRepository)
        self.dataRepository.store(authCredentials)
        objc_sync_exit(self.dataRepository)
    }

    public func getAuthCredentials() throws -> AuthCredentials {
        if let authCredentials = self.dataRepository.get(AuthCredentials.self) {
            return authCredentials
        }
        throw BSANIllegalStateException("AuthCredentials nil in DataRepository")
    }

    // MARK: - Trusted Device Headers
    public func storeTrustedDeviceHeaders(_ trustedDeviceHeaders: TrustedDeviceHeaders) {
        objc_sync_enter(self.dataRepository)
        self.dataRepository.store(trustedDeviceHeaders,
                                  BSANDatabaseKey.TrustedDeviceHeaders.rawValue ,
                                  .createPersistentPolicy())
        objc_sync_exit(self.dataRepository)
    }
    
    public func getTrustedDeviceHeaders() -> TrustedDeviceHeaders? {
        let trustedDeviceHeaders = self.dataRepository.get(TrustedDeviceHeaders.self,
                                                           BSANDatabaseKey.TrustedDeviceHeaders.rawValue,
                                                           .createPersistentPolicy())
        return trustedDeviceHeaders
    }
    
    public func deleteTrustedDeviceHeaders() {
        self.dataRepository.remove(TrustedDeviceHeaders.self,
                                   BSANDatabaseKey.TrustedDeviceHeaders.rawValue,
                                   .createPersistentPolicy())
    }
    
    // MARK: - Trusted Device Info
    public func storeTrustedDeviceInfo(_ info: TrustedDeviceInfo) {
        objc_sync_enter(self.dataRepository)
        self.dataRepository.store(info,
                                  BSANDatabaseKey.TrustedDeviceInfo.rawValue,
                                  .createPersistentPolicy())
        objc_sync_exit(self.dataRepository)
    }
        
    public func getTrustedDeviceInfo() -> TrustedDeviceInfo? {
        let trustedDeviceInfo = self.dataRepository.get(TrustedDeviceInfo.self,
                                                        BSANDatabaseKey.TrustedDeviceInfo.rawValue,
                                                        .createPersistentPolicy())
        return trustedDeviceInfo
    }
    
    public func deleteTrustedDeviceInfo() {
        self.dataRepository.remove(TrustedDeviceInfo.self,
                                   BSANDatabaseKey.TrustedDeviceInfo.rawValue,
                                   .createPersistentPolicy())
    }

    // MARK: - Encrypted User Keys
    public func storeEncryptedUserKeys(_ encryptedKeys: EncryptedUserKeys) {
        objc_sync_enter(self.dataRepository)
        self.dataRepository.store(encryptedKeys,
                                  BSANDatabaseKey.TrustedDeviceUserKeys.rawValue,
                                  .createPersistentPolicy())
        objc_sync_exit(self.dataRepository)
    }

    public func deleteEncryptedUserKeys() {
        self.dataRepository.remove(EncryptedUserKeys.self,
                                   BSANDatabaseKey.TrustedDeviceUserKeys.rawValue,
                                   .createPersistentPolicy())
    }

    public func getEncryptedUserKeys() -> EncryptedUserKeys? {
        let encryptedUserKeys = self.dataRepository.get(EncryptedUserKeys.self,
                                                        BSANDatabaseKey.TrustedDeviceUserKeys.rawValue,
                                                        .createPersistentPolicy())
        return encryptedUserKeys
    }

    // MARK: - Demo User
    public func setDemoMode(_ isDemo: Bool, _ demoUser: String?) {
        if isDemo, let demoUser = demoUser {
            objc_sync_enter(dataRepository)
            dataRepository.store(DemoMode(demoUser))
            objc_sync_exit(dataRepository)
        } else {
            dataRepository.remove(DemoMode.self)
        }
    }
    
    public func isDemo() -> Bool {
        return dataRepository.get(DemoMode.self) != nil
    }
    
    // MARK: - Session Data
    public func createSessionData(_ userDTO: UserDTO) {
        let sessionData = SessionData(userDTO)
        objc_sync_enter(dataRepository)
        dataRepository.store(sessionData)
        objc_sync_exit(dataRepository)
    }

    public func cleanSessionData() throws {
        let sessionData = try self.getSessionData()
        let userDTO = sessionData.loggedUserDTO
        self.dataRepository.remove(SessionData.self)
        self.createSessionData(userDTO)
    }

    public func getSessionData() throws -> SessionData {
        if let sessionData = dataRepository.get(SessionData.self) {
            return sessionData
        }
        throw BSANIllegalStateException("SessionData nil in DataRepository")
    }

    public func updateSessionData(_ sessionData: SessionData) {
        objc_sync_enter(dataRepository)
        dataRepository.store(sessionData)
        objc_sync_exit(dataRepository)
    }

    // MARK: - Global Position
    public func store(_ newGlobalPositionDTO: GlobalPositionDTO) {
        objc_sync_enter(dataRepository)
        if let sessionData = try? getSessionData() {
            sessionData.globalPositionDTO = newGlobalPositionDTO
            updateSessionData(sessionData)
        }
        objc_sync_exit(dataRepository)
    }

    public func getGlobalPosition() -> GlobalPositionDTO? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.globalPositionDTO
    }

    // MARK: - Loan Operation List
    public func store(loanOperationList: LoanOperationListDTO, forLoanId loanId: String) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.loanInfo.loanOperationsDictionary[loanId] = loanOperationList
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(self.dataRepository)
    }

    public func getLoanOperationList(withLoanId loanId: String) -> LoanOperationListDTO? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.loanInfo.loanOperationsDictionary[loanId]
    }

    // MARK: - Loan Detail
    public func store(loanDetail: LoanDetailDTO, forLoanId loanId: String) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.loanInfo.loanDetailDictionary[loanId] = loanDetail
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(dataRepository)
    }

    public func getLoanDetail(withLoanId loanId: String) -> LoanDetailDTO? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.loanInfo.loanDetailDictionary[loanId]
    }

    // MARK: - Card PAN
    public func getCardPAN(cardId: String) -> String? {
        // TODO: Cards - To be implemented when Card PAN API is implemented and PANs are saved into SessionData
        return nil
    }
    
    // MARK: - Account Detail
    public func store(accountDetail: AccountDetailDTO, forAccountId accountId: String) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.accountInfo.accountDetailDictionary[accountId] = accountDetail
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(self.dataRepository)
    }

    public func getAccountDetail(withAccountId accountId: String) -> AccountDetailDTO? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.accountInfo.accountDetailDictionary[accountId]
    }

    // MARK: - Swift Branches
    public func store(swiftBranches: SwiftBranchesDTO, forAccountId accountId: String) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.accountInfo.swiftBranchesDictionary[accountId] = swiftBranches
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(self.dataRepository)
    }

    public func getSwiftBranches(withAccountId accountId: String) -> SwiftBranchesDTO? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.accountInfo.swiftBranchesDictionary[accountId]
    }
    
    // MARK: - Holding List
    public func store(withholdingListDTO: WithholdingListDTO, forAccountId accountId: String) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.accountInfo.withHoldingListDictionary[accountId] = withholdingListDTO
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(self.dataRepository)
    }
    
    public func getWithholdingList(withAccountId accountId: String) -> WithholdingListDTO? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.accountInfo.withHoldingListDictionary[accountId]
    }
    
    // MARK: - Card Transactions
    public func storeCardTransactions(_ cardId: String, _ dto: CardTransactionListDTO) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.cardsTransactions[cardId] = dto
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(self.dataRepository)
    }
    
    public func storeCardPagination(_ cardId: String, _ pagination: TransactionsLinksDTO) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.cardTransactionsPagination[cardId] = pagination
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(self.dataRepository)
    }
    
    // MARK: - Customer
    public func storeCustomerIndivual(dto: CustomerDTO) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.customer = dto
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(self.dataRepository)
    }
    
    public func getCustomerIndividual() -> CustomerDTO? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.customer
    }

    // MARK: - CreditCardRepayment Cache
    public func store(creditCardRepaymentDebitAccounts accounts: [CCRAccountDTO]) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.creditCardRepaymentInfo.accountsForDebit = accounts
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(dataRepository)
    }
    
    public func store(creditCardRepaymentCreditAccounts accounts: [CCRAccountDTO]) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.creditCardRepaymentInfo.accountsForCredit = accounts
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(dataRepository)
    }
    
    public func store(creditCardRepaymentCards cards: [CCRCardDTO]) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.creditCardRepaymentInfo.cards = cards
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(dataRepository)
    }
    
    public func getCreditCardRepaymentInfo() -> CreditCardRepaymentInfo? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.creditCardRepaymentInfo
    }
    
    public func cleanCreditCardRepaymentInfo() {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.creditCardRepaymentInfo.accountsForDebit = []
            sessionData.creditCardRepaymentInfo.accountsForCredit = []
            sessionData.creditCardRepaymentInfo.cards = []
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(dataRepository)
    }
    
    // MARK: - Help Center Cache
    public func store(helpCenterOnlineAdvisor onlineAdvisor: OnlineAdvisorDTO) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.helpCenterInfo.onlineAdvisor = onlineAdvisor
            sessionData.helpCenterInfo.onlineAdvisorStoreDate = Date()
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(dataRepository)
    }
    
    public func getHelpCenterInfo() -> HelpCenterInfo? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.helpCenterInfo
    }
    
    public func store(helpCenterHelpQuestions helpQuestions: HelpQuestionsDTO) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.helpQuestionsInfo.helpQuestions = helpQuestions
            sessionData.helpQuestionsInfo.helpQuestionsStoreDate = Date()
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(dataRepository)
    }
    
    public func getHelpQuestionsInfo() -> HelpQuestionsInfo? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.helpQuestionsInfo
    }
    

    // MARK: - Login public key store management
    public func storePublicKey(_ pubKey: PubKeyDTO) {
        objc_sync_enter(dataRepository)
        dataRepository.store(pubKey)
        objc_sync_exit(dataRepository)
    }

    public func getPublicKey() throws -> PubKeyDTO {
        if let pubKeyDTO = dataRepository.get(PubKeyDTO.self) {
            return pubKeyDTO
        }
        throw BSANIllegalStateException("PubKeyDTO is nil in DataRepository")
    }

    public func removePublicKey() {
        self.dataRepository.remove(PubKeyDTO.self)
    }

    // MARK: - Close session
    public func closeSession() {
        self.dataRepository.remove(AuthCredentials.self)
        self.dataRepository.remove(SessionData.self)
    }
    
    public func storeDeviceId(_ deviceId: String) {
             dataRepository.store(
                 deviceId,
                 BSANDatabaseKey.DeviceId.rawValue,
                 .createPersistentPolicy()
             )
             objc_sync_exit(dataRepository)
         }

         public func getDeviceId() -> String? {
             dataRepository.get(
                 String.self,
                 BSANDatabaseKey.DeviceId.rawValue,
                 .createPersistentPolicy()
             )
         }

         public func deleteDeviceId() {
             self.dataRepository.remove(
                 String.self,
                 BSANDatabaseKey.DeviceId.rawValue,
                 .createPersistentPolicy()
             )
         }
}

//MARK: -
extension BSANDataProvider: BSANDemoProviderProtocol {
    
    public func getDemoMode() -> DemoMode? {
        return dataRepository.get(DemoMode.self)
    }
}

extension BSANDataProvider: BSANDataProviderProtocol {
    public func getAuthCredentialsProvider() throws -> AuthCredentialsProvider {
        return try getAuthCredentials()
    }
    
    public func getLanguageISO() throws -> String {
        return "pl"
    }
    
    public func getDialectISO() throws -> String {
        return "PL"
    }
}

//
//  BSANDataProvider.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import DataRepository
import SANLegacyLibrary

public class BSANDataProvider {
    
    private var dataRepository: DataRepository
    
    public init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }
    
    public func storeAppInfo(_ appInfo: AppInfo) {
        objc_sync_enter(dataRepository)
        dataRepository.store(appInfo, .createPersistentPolicy())
        objc_sync_exit(dataRepository)
    }
    
    public func getAppInfo() -> AppInfo? {
        return dataRepository.get(AppInfo.self, .createPersistentPolicy())
    }
    
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


    public func storeTrustedDeviceHeaders(_ trustedDeviceHeaders: TrustedDeviceHeaders) {
        objc_sync_enter(self.dataRepository)
        self.dataRepository.store(trustedDeviceHeaders, DataRepositoryPolicy.createPersistentPolicy())
        objc_sync_exit(self.dataRepository)
    }
    
    public func deleteTrustedDeviceHeaders() {
        self.dataRepository.remove(TrustedDeviceHeaders.self, .createPersistentPolicy())
    }

    public func getTrustedDeviceHeaders() -> TrustedDeviceHeaders? {
        guard let trustedDeviceHeaders = self.dataRepository.get(TrustedDeviceHeaders.self, DataRepositoryPolicy.createPersistentPolicy()) else {
            return nil
        }
        return trustedDeviceHeaders
    }

    public func storeEncryptedUserKeys(_ encryptedKeys: EncryptedUserKeys) {
        objc_sync_enter(self.dataRepository)
        self.dataRepository.store(encryptedKeys, DataRepositoryPolicy.createPersistentPolicy())
        objc_sync_exit(self.dataRepository)
    }

    public func deleteEncryptedUserKeys() {
        self.dataRepository.remove(TrustedDeviceHeaders.self, .createPersistentPolicy())
    }

    public func getEncryptedUserKeys() -> EncryptedUserKeys? {
        guard let encryptedKeys = self.dataRepository.get(EncryptedUserKeys.self, DataRepositoryPolicy.createPersistentPolicy()) else {
            return nil
        }
        return encryptedKeys
    }

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

    public func getCardPAN(cardId: String) -> String? {
        // TODO: Cards - To be implemented when Card PAN API is implemented and PANs are saved into SessionData
        return nil
    }
    
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
    
    public func storeCardTransactions(_ cardId: String, _ dto: CardTransactionListDTO) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.cardsTransactions[cardId] = dto
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(self.dataRepository)
    }
    
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

    // MARK: CreditCardRepayment Cache
    
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
    
    // MARK: Help Center Cache
    
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
    

    // MARK: Login public key store management
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

    public func closeSession() {
        self.dataRepository.remove(AuthCredentials.self)
        self.dataRepository.remove(SessionData.self)
    }
}

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

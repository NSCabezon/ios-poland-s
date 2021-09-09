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

    public func getTrustedDeviceHeaders() -> TrustedDeviceHeaders? {
        guard let trustedDeviceHeaders = self.dataRepository.get(TrustedDeviceHeaders.self, DataRepositoryPolicy.createPersistentPolicy()) else {
            return nil
        }
        return trustedDeviceHeaders
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

    public func store(accountTransactions: AccountTransactionsDTO, forAccountId accountId: String) {
        objc_sync_enter(self.dataRepository)
        if let sessionData = try? self.getSessionData() {
            sessionData.accountInfo.transactionsDictionary[accountId] = accountTransactions
            self.updateSessionData(sessionData)
        }
        objc_sync_exit(self.dataRepository)
    }

    public func getAccountTransactions(withAccountId accountId: String) -> AccountTransactionsDTO? {
        guard let sessionData = try? self.getSessionData() else {
            return nil
        }
        return sessionData.accountInfo.transactionsDictionary[accountId]
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

import Foundation

public protocol PLBLIKManagerProtocol {
    func getPSPTicket() throws -> Result<GetPSPDTO, NetworkProviderError>
    func getWalletsActive() throws -> Result<[GetWalletsActiveDTO], NetworkProviderError>
    func getTrnToConf() throws -> Result<GetTrnToConfDTO, NetworkProviderError>
    func getActiveCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError>
    func getArchivedCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError>
    func getWalletParams() throws -> Result<WalletParamsDTO, NetworkProviderError>
    func cancelCheque(chequeId: Int) throws -> Result<Void, NetworkProviderError>
    func setChequePin(request: SetChequeBlikPinParameters) throws -> Result<Void, NetworkProviderError>
    func createCheque(request: CreateChequeRequestDTO) throws -> Result<CreateChequeResponseDTO, NetworkProviderError>
    func cancelTransaction(request: CancelBLIKTransactionRequestDTO, trnId: Int) throws -> Result<Void, NetworkProviderError>
    func getPinPublicKey() throws -> Result<PubKeyDTO, NetworkProviderError>
    func getAccounts() throws -> Result<[DebitAccountDTO], NetworkProviderError>
    func acceptTransaction(trnId: Int, trnDate: String) throws -> Result<Void, NetworkProviderError>
    func phoneVerification(aliases: [String]) throws -> Result<PhoneVerificationDTO, NetworkProviderError>
    func setPSPAliasLabel(_ label: String) throws -> Result<Void, NetworkProviderError>
    func unregisterPhoneNumber() throws -> Result<Void, NetworkProviderError>
    func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<RegisterPhoneNumberResponseDTO, NetworkProviderError>
    func setTransactionLimits(_ request: TransactionLimitRequestDTO) throws -> Result<Void, NetworkProviderError>
    func getAliases() throws -> Result<[BlikAliasDTO], NetworkProviderError>
    func deleteAlias(_ request: DeleteBlikAliasParameters) throws -> Result<Void, NetworkProviderError>
    func registerAlias(_ request: RegisterBlikAliasParameters) throws -> Result<Void, NetworkProviderError>
    func p2pAlias(msisdn: String) throws -> Result<P2pAliasDTO, NetworkProviderError>
    func acceptTransfer(_ parameters: AcceptDomesticTransactionParameters) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError>
}

public final class PLBLIKManager {
    private let dataSource: BLIKDataSource
    private let bsanDataProvider: BSANDataProvider
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.dataSource = BLIKDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
    }
}

extension PLBLIKManager: PLBLIKManagerProtocol {
    public func getWalletsActive() throws -> Result<[GetWalletsActiveDTO], NetworkProviderError> {
        try dataSource.getWalletsActive()
    }
    
    public func getPSPTicket() throws -> Result<GetPSPDTO, NetworkProviderError> {
        try dataSource.getPSPTicket()
    }

    public func getTrnToConf() throws -> Result<GetTrnToConfDTO, NetworkProviderError> {
        try dataSource.getTrnToConf()
    }

    public func getActiveCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError> {
        try dataSource.getActiveCheques()
    }
    
    public func getArchivedCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError> {
        try dataSource.getArchivedCheques()
    }
    
    public func getWalletParams() throws -> Result<WalletParamsDTO, NetworkProviderError> {
        try dataSource.getWalletParams()
    }
    
    public func cancelCheque(chequeId: Int) throws -> Result<Void, NetworkProviderError> {
        try dataSource.cancelCheque(chequeId: chequeId)
    }
    
    public func setChequePin(request: SetChequeBlikPinParameters) throws -> Result<Void, NetworkProviderError> {
        try dataSource.setChequePin(request: request)
    }
    
    public func createCheque(request: CreateChequeRequestDTO) throws -> Result<CreateChequeResponseDTO, NetworkProviderError> {
        try dataSource.createCheque(request: request)
    }

    public func cancelTransaction(request: CancelBLIKTransactionRequestDTO, trnId: Int) throws -> Result<Void, NetworkProviderError> {
        try dataSource.cancelTransaction(request: request, trnId: trnId)
    }

    public func getPinPublicKey() throws -> Result<PubKeyDTO, NetworkProviderError> {
        try dataSource.getPinPublicKey()
    }
    
    public func getAccounts() throws -> Result<[DebitAccountDTO], NetworkProviderError> {
        try dataSource.getAccounts()
    }
    
    public func acceptTransaction(trnId: Int, trnDate: String) throws -> Result<Void, NetworkProviderError> {
        try dataSource.acceptTransaction(trnId: trnId, trnDate: trnDate)
    }
    
    public func phoneVerification(aliases: [String]) throws -> Result<PhoneVerificationDTO, NetworkProviderError> {
        try dataSource.phoneVerification(aliases: aliases)
    }
    
    public func p2pAlias(msisdn: String) throws -> Result<P2pAliasDTO, NetworkProviderError> {
        try dataSource.p2pAlias(msisdn: msisdn)
    }

    public func setPSPAliasLabel(_ label: String) throws -> Result<Void, NetworkProviderError> {
        try dataSource.setPSPAliasLabel(label)
    }
    
    public func unregisterPhoneNumber() throws -> Result<Void, NetworkProviderError> {
        try dataSource.unregisterPhoneNumber()
    }
    
    public func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<RegisterPhoneNumberResponseDTO, NetworkProviderError> {
        try dataSource.registerPhoneNumber(request)
    }
    
    public func setTransactionLimits(_ request: TransactionLimitRequestDTO) throws -> Result<Void, NetworkProviderError> {
        try dataSource.setTransactionLimits(request)
    }
    public func getAliases() throws -> Result<[BlikAliasDTO], NetworkProviderError> {
        try dataSource.getAliases()
    }
    
    public func deleteAlias(_ request: DeleteBlikAliasParameters) throws -> Result<Void, NetworkProviderError> {
        try dataSource.deleteAlias(request)
    }
    
    public func acceptTransfer(_ parameters: AcceptDomesticTransactionParameters) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        try dataSource.acceptTransfer(parameters)
    }
    
    public func registerAlias(_ request: RegisterBlikAliasParameters) throws -> Result<Void, NetworkProviderError> {
        try dataSource.registerAlias(request)
    }
}

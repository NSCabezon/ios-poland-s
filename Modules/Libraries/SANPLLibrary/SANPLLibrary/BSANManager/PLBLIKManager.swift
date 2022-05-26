
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
    func getAccounts() throws -> Result<[BlikCustomerAccountDTO], NetworkProviderError>
    func acceptTransaction(_ parameters: BlikAcceptTransactionParameters) throws -> Result<Void, NetworkProviderError>
    func phoneVerification(aliases: [String]) throws -> Result<PhoneVerificationDTO, NetworkProviderError>
    func setPSPAliasLabel(_ parameters: SetPSPAliasLabelParameters) throws -> Result<Void, NetworkProviderError>
    func setTransactionDataVisibility(_ parameters: SetNoPinTrnVisibleParameters) throws -> Result<Void, NetworkProviderError>
    func unregisterPhoneNumber() throws -> Result<Void, NetworkProviderError>
    func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<Void, NetworkProviderError>
    func setTransactionLimits(_ request: TransactionLimitRequestDTO) throws -> Result<Void, NetworkProviderError>
    func getAliases() throws -> Result<[BlikAliasDTO], NetworkProviderError>
    func deleteAlias(_ request: DeleteBlikAliasParameters) throws -> Result<Void, NetworkProviderError>
    func registerAlias(_ parameters: RegisterBlikAliasParameters) throws -> Result<Void, NetworkProviderError>
    func p2pAlias(msisdn: String) throws -> Result<P2pAliasDTO, NetworkProviderError>
    func acceptTransfer(
        _ parameters: AcceptDomesticTransactionParameters,
        transactionParameters: TransactionParameters?
    ) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError>
    func getTransactions() throws -> Result<BlikTransactionDTO, NetworkProviderError>
    func getChallenge(_ parameters: BlikChallengeParameters) throws -> Result<BlikChallengeDTO, NetworkProviderError>
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
    
    public func getAccounts() throws -> Result<[BlikCustomerAccountDTO], NetworkProviderError> {
        try dataSource.getAccounts()
    }
    
    public func acceptTransaction(_ parameters: BlikAcceptTransactionParameters) throws -> Result<Void, NetworkProviderError> {
        try dataSource.acceptTransaction(parameters)
    }
    
    public func phoneVerification(aliases: [String]) throws -> Result<PhoneVerificationDTO, NetworkProviderError> {
        try dataSource.phoneVerification(aliases: aliases)
    }
    
    public func p2pAlias(msisdn: String) throws -> Result<P2pAliasDTO, NetworkProviderError> {
        try dataSource.p2pAlias(msisdn: msisdn)
    }

    public func setPSPAliasLabel(_ parameters: SetPSPAliasLabelParameters) throws -> Result<Void, NetworkProviderError> {
        try dataSource.setPSPAliasLabel(parameters)
    }
    
    public func setTransactionDataVisibility(_ parameters: SetNoPinTrnVisibleParameters) throws -> Result<Void, NetworkProviderError> {
        try dataSource.setTransactionDataVisibility(parameters)
    }
    
    public func unregisterPhoneNumber() throws -> Result<Void, NetworkProviderError> {
        try dataSource.unregisterPhoneNumber()
    }
    
    public func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<Void, NetworkProviderError> {
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

    public func acceptTransfer(
        _ parameters: AcceptDomesticTransactionParameters,
        transactionParameters: TransactionParameters?
    ) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        try dataSource.acceptTransfer(parameters, transactionParameters: transactionParameters)
    }
    
    public func registerAlias(_ parameters: RegisterBlikAliasParameters) throws -> Result<Void, NetworkProviderError> {
        try dataSource.registerAlias(parameters)
    }
    
    public func getTransactions() throws -> Result<BlikTransactionDTO, NetworkProviderError> {
        try dataSource.getTransactions()
    }
    
    public func getChallenge(_ parameters: BlikChallengeParameters) throws -> Result<BlikChallengeDTO, NetworkProviderError> {
        try dataSource.getChallenge(parameters)
    }
}

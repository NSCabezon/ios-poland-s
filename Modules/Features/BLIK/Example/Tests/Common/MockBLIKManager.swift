import SANPLLibrary
import PLCryptography

struct MockBLIKManager: PLBLIKManagerProtocol {
    
    func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }

    func registerPhoneNumber(_ request: RegisterPhoneNumberRequestDTO) throws -> Result<RegisterPhoneNumberResponseDTO, NetworkProviderError> {
        fatalError()
    }
    
    func setTransactionLimits(_ request: TransactionLimitRequestDTO) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func getAliases() throws -> Result<[BlikAliasDTO], NetworkProviderError> {
        fatalError()
    }
    
    func deleteAlias(_ request: DeleteBlikAliasParameters) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func registerAlias(_ request: RegisterBlikAliasParameters) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    private let forceError: Bool
    
    @DecodeFile(name: "getTrnToConfResponse")
    private var transaction: GetTrnToConfDTO
    
    init(forceError: Bool = false) {
        self.forceError = forceError
    }
    
    
    func p2pAlias(msisdn: String) throws -> Result<P2pAliasDTO, NetworkProviderError> {
        guard !forceError else { return .failure(.other)}
        return .success(P2pAliasDTO(dstAccNo: "12 3456 7890 1234 5678 9012 3456", isDstAccInternal: true))
    }
    
    func phoneVerification(aliases: [String]) throws -> Result<PhoneVerificationDTO, NetworkProviderError> {
        .success(.init(aliases: [
            "48123456789".sha256(),
            "48987654321".sha256()
        ]))
    }
    
    func setPSPAliasLabel(_ label: String) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func acceptTransaction(trnId: Int, trnDate: String) throws -> Result<Void, NetworkProviderError> {
        .success(Void())
    }

    func getPSPTicket() throws -> Result<GetPSPDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getWalletsActive() throws -> Result<[GetWalletsActiveDTO], NetworkProviderError> {
        fatalError()
    }
    
    func getTrnToConf() throws -> Result<GetTrnToConfDTO, NetworkProviderError> {
        guard !forceError else { return .failure(.other) }
        
        return .success(transaction)
    }
    
    func getActiveCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError> {
        fatalError()
    }
    
    func getArchivedCheques() throws -> Result<[BlikChequeDTO], NetworkProviderError> {
        fatalError()
    }
    
    func cancelCheque(chequeId: Int) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func createCheque(request: CreateChequeRequestDTO) throws -> Result<CreateChequeResponseDTO, NetworkProviderError> {
        fatalError()
    }
    
    func cancelTransaction(request: CancelBLIKTransactionRequestDTO, trnId: Int) throws -> Result<Void, NetworkProviderError> {
        guard !forceError else { return .failure(.other) }
        
        return .success(Void())
    }
    
    func getPinPublicKey() throws -> Result<PubKeyDTO, NetworkProviderError> {
        fatalError()
    }
    
    func unregisterPhoneNumber() throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func acceptTransfer(_ parameters: AcceptDomesticTransactionParameters, transactionParameters: TransactionParameters?) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getWalletParams() throws -> Result<WalletParamsDTO, NetworkProviderError> {
        fatalError()
    }
    
    func setChequePin(request: SetChequeBlikPinParameters) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func getAccounts() throws -> Result<[DebitAccountDTO], NetworkProviderError> {
        fatalError()
    }
    
    func setPSPAliasLabel(_ parameters: SetPSPAliasLabelParameters) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func getTransactions() throws -> Result<BlikTransactionDTO, NetworkProviderError> {
        fatalError()
    }
    
    func getAccounts() throws -> Result<[BlikCustomerAccountDTO], NetworkProviderError> {
        fatalError()
    }
    
    func acceptTransfer(_ parameters: AcceptDomesticTransactionParameters, transactionParameters: String?) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        fatalError()
    }
    
    func setTransactionDataVisibility(_ parameters: SetNoPinTrnVisibleParameters) throws -> Result<Void, NetworkProviderError> {
        fatalError()
    }
    
    func getChallenge(_ parameters: BlikChallengeParameters) throws -> Result<BlikChallengeDTO, NetworkProviderError> {
        fatalError()
    }
}

import SANPLLibrary
import Commons
import CoreDomain
import PLCommons

final class PLTransfersManagerSuccessMock: PLTransfersManagerProtocol {
    
    private let dependenciesResolver: DependenciesResolver
   
    @DecodeFile(name: "setConfirmationResponse",
                bundle: Bundle(for: PLTransfersManagerSuccessMock.self))
    private var transaction: ConfirmationTransferDTO
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getTransactionParameters(type: PLDomesticTransactionParametersType?) -> TransactionParameters? {
        nil
    }
    
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], NetworkProviderError> {
        fatalError()
    }
    
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[PayeeDTO], NetworkProviderError> {
        fatalError()
    }
    
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<CheckInternalAccountRepresentable, NetworkProviderError> {
        fatalError()
    }
    
    func getRecentRecipients() throws -> Result<[TransferRepresentable], NetworkProviderError> {
        fatalError()
    }
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError> {
        fatalError()
    }
    
    func checkFinalFee(_ parameters: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], NetworkProviderError> {
        fatalError()
    }
    
    func sendConfirmation(_ parameters: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, NetworkProviderError> {
        .success(transaction)
    }
    
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionAvailabilityRepresentable, NetworkProviderError> {
        fatalError()
    }
    
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError> {
        fatalError()
    }
}

import SANPLLibrary
import CoreFoundationLib
import CoreDomain
import PLCommons

final class PLTransfersManagerSuccessMock: PLTransfersManagerProtocol {
    
    private let dependenciesResolver: DependenciesResolver
    
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
        return .success(RecipientsBuilderMock.getPayeeListDtoMock() ?? [])
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
        fatalError()
    }
    
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionAvailabilityRepresentable, NetworkProviderError> {
        fatalError()
    }
    
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError> {
        fatalError()
    }
}

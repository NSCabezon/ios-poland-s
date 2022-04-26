import SANPLLibrary
import CoreDomain
import OpenCombine

final class PLTransfersRepositoryMock: PLTransfersRepository {
    func sendConfirmation(input: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, Error> {
        fatalError()
    }
    
    func getAccountsForCredit() throws -> Result<[AccountRepresentable], Error> {
        fatalError()
    }
    
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], Error> {
        fatalError()
    }
    
    func getExchangeRates() -> AnyPublisher<[ExchangeRateRepresentable], Error> {
        fatalError()
    }
    
    func loadAllUsualTransfers() -> AnyPublisher<[PayeeRepresentable], Error> {
        fatalError()
    }
    
    func noSepaPayeeDetail(of alias: String, recipientType: String) -> AnyPublisher<NoSepaPayeeDetailRepresentable, Error> {
        fatalError()
    }
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError> {
        .success(SendMoneyChallengeMock())
    }
    
    func getAccountForDebit() throws -> Result<[AccountRepresentable], Error> {
        fatalError()
    }
    
    func checkTransactionAvailability(input: CheckTransactionAvailabilityInput) throws -> Result<CheckTransactionAvailabilityRepresentable, Error> {
        fatalError()
    }
    
    func getFinalFee(input: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], Error> {
        fatalError()
    }
    
    func checkInternalAccount(input: CheckInternalAccountInput) throws -> Result<CheckInternalAccountRepresentable, Error> {
        fatalError()
    }
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, Error> {
        .success(SendMoneyChallengeMock())
    }
    
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError> {
        .success(AuthorizationIdMock())
    }
    
    func transferType(originAccount: AccountRepresentable, selectedCountry: String, selectedCurrerncy: String) throws -> Result<TransfersType, Error> {
        fatalError()
    }
    
    func validateGenericTransfer(originAccount: AccountRepresentable, nationalTransferInput: SendMoneyGenericTransferInput) throws -> Result<ValidateAccountTransferRepresentable, Error> {
        fatalError()
    }
    
    func validateDeferredTransfer(originAcount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
        fatalError()
    }
    
    func validatePeriodicTransfer(originAcount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
        fatalError()
    }
    
    func validateGenericTransferOTP(originAccount: AccountRepresentable, nationalTransferInput: NationalTransferInputRepresentable, signature: SignatureRepresentable) throws -> Result<OTPValidationRepresentable, Error> {
        fatalError()
    }
    
    func validatePeriodicTransferOTP(signature: SignatureRepresentable, dataToken: String) throws -> Result<OTPValidationRepresentable, Error> {
        fatalError()
    }
    
    func validateDeferredTransferOTP(signature: SignatureRepresentable, dataToken: String) throws -> Result<OTPValidationRepresentable, Error> {
        fatalError()
    }
    
    func confirmGenericTransfer(originAccount: AccountRepresentable, nationalTransferInput: SendMoneyGenericTransferInput, otpValidation: OTPValidationRepresentable?, otpCode: String?) throws -> Result<TransferConfirmAccountRepresentable, Error> {
        fatalError()
    }
    
    func confirmDeferredTransfer(originAccount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput, otpValidation: OTPValidationRepresentable, otpCode: String) throws -> Result<Void, Error> {
        fatalError()
    }
    
    func confirmPeriodicTransfer(originAccount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput, otpValidation: OTPValidationRepresentable, otpCode: String) throws -> Result<Void, Error> {
        fatalError()
    }
}

struct SendMoneyChallengeMock: SendMoneyChallengeRepresentable {
    var challengeRepresentable: String? {
        "97216838"
    }
}

struct AuthorizationIdMock: AuthorizationIdRepresentable {
    var authorizationId: Int? {
        587
    }
}



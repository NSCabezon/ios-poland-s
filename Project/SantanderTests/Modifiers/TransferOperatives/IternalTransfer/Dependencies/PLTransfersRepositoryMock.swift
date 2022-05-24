//
//  PLTransfersRepositoryMock.swift
//  SantanderTests
//
//  Created by Mario Rosales Maillo on 10/3/22.
//

import Foundation
import TransferOperatives
import SANPLLibrary
import CoreDomain
import OpenCombine
@testable import IDZSwiftCommonCrypto

struct PLTransfersRepositoryMock: PLTransfersRepository {

    private var rates: [ExchangeRateRepresentable]!
    
    public init(rates: [ExchangeRateRepresentable]) {
        self.rates = rates
    }
    
    func getAccountsForCredit() throws -> Result<[AccountRepresentable], Error> {
        fatalError()
    }
    
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], Error> {
        fatalError()
    }
    
    func sendConfirmation(input: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, Error> {
        fatalError()
    }
    
    func getAccountsForDebitSwitch() -> AnyPublisher<[AccountRepresentable], Error> {
        fatalError()
    }
    
    func getAccountsForCreditSwitch(_ accountType: String) -> AnyPublisher<[AccountRepresentable], Error> {
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
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError> {
        fatalError()
    }
    
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError> {
        fatalError()
    }
    
    func getExchangeRatesReactive() -> AnyPublisher<[ExchangeRateRepresentable], Error> {
        return Just(self.rates).tryMap({ result in
            return result
        }).eraseToAnyPublisher()
    }
    
    func getExchangeRates() throws -> Result<[ExchangeRateRepresentable], Error> {
        return .success(self.rates)
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
    
    func loadAllUsualTransfers() -> AnyPublisher<[PayeeRepresentable], Error> {
        fatalError()
    }
    
    func noSepaPayeeDetail(of alias: String, recipientType: String) -> AnyPublisher<NoSepaPayeeDetailRepresentable, Error> {
        fatalError()
    }
    
    func getAccountDetail(_ parameters: GetPLAccountDetailInput) -> AnyPublisher<PLAccountDetailRepresentable, Error> {
        var accountDetail = PLAccountDetailRepresentedMock(name: nil)
        if isLenghtAccountNumberCorrect(parameters.accountNumber) {
            accountDetail = PLAccountDetailRepresentedMock(name: "Full Name")
        }
        return Just(accountDetail)
            .tryMap({ result in
                return result
            })
            .eraseToAnyPublisher()
    }
}

private extension PLTransfersRepositoryMock {
    func isLenghtAccountNumberCorrect(_ account: String) -> Bool {
        return account.count == 26
    }
}

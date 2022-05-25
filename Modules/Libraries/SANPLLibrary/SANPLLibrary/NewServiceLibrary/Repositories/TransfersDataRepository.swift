//
//  TransferDataRepository.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 6/10/21.
//

import SANLegacyLibrary
import OpenCombine
import CoreDomain

struct TransfersDataRepository: PLTransfersRepository {

    let bsanTransferManager: PLTransfersManagerProtocol
    
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], Error> {
        let response = try bsanTransferManager.getAccountsForDebit()
        switch response {
        case .success(let accounts):
            return .success(accounts)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getAccountsForCredit() throws -> Result<[AccountRepresentable], Error> {
        let response = try bsanTransferManager.getAccountsForCredit()
        switch response {
        case .success(let accounts):
            return .success(accounts)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func sendConfirmation(input: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, Error> {
        let response = try bsanTransferManager.sendConfirmation(input)
        switch response {
        case .success(let confirmationTransferDTO):
            return .success(confirmationTransferDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func checkTransactionAvailability(input: CheckTransactionAvailabilityInput) throws -> Result<CheckTransactionAvailabilityRepresentable, Error> {
        let iban = input.destinationAccount
        let ibanFormatted = iban.countryCode + iban.checkDigits + iban.codBban
        let parameters = CheckTransactionParameters(customerProfile: "SAN_PL", transactionAmount: "\(input.transactionAmount?.wholePart ?? "0").\(input.transactionAmount?.getDecimalPart() ?? "00")", hasSplitPayment: false)
        let response = try bsanTransferManager.checkTransaction(parameters: parameters, accountReceiver: ibanFormatted)
        switch response {
        case .success(let transactionAvailability):
            return .success(transactionAvailability)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getFinalFee(input: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], Error> {
        let response = try bsanTransferManager.checkFinalFee(input)
        switch response {
        case .success(let finalFeeResponse):
            return .success(finalFeeResponse)
        case .failure(let error):
            return .failure(error)
        }
    }
        
    func checkInternalAccount(input: CheckInternalAccountInput) throws -> Result<CheckInternalAccountRepresentable, Error> {
        let codBban = input.destinationAccount.checkDigits + input.destinationAccount.codBban.replacingOccurrences(of: " ", with: "")
        if codBban.count > 0 {
            let start = codBban.index(codBban.startIndex, offsetBy: 2)
            let end = codBban.index(codBban.startIndex, offsetBy: 10)
            let range = start..<end
            let branchId = String(codBban[range])
            let inputParams = IBANValidationParameters(accountNumber: codBban,
                                                       branchId: branchId)
            let response = try bsanTransferManager.doIBANValidation(inputParams)
            switch response {
            case .success(let validateAccount):
                return.success(validateAccount)
            case .failure(let error):
                guard let errorDTO: PLErrorDTO = error.getErrorBody() else { return .failure(NetworkProviderError.other)}
                return .failure(
                    NetworkProviderError.error(
                        NetworkProviderResponseError(
                            code: errorDTO.errorCode2,
                            data: nil,
                            headerFields: nil,
                            error: error
                        )
                    )
                )
            }
        } else {
            return .failure(ServiceError.unknown)
        }
    }
    
    func transferType(originAccount: AccountRepresentable, selectedCountry: String, selectedCurrerncy: String) throws -> Result<TransfersType, Error> {
        guard selectedCountry == "PL" && selectedCurrerncy == "PLN" else {
            return.success(.INTERNATIONAL_NO_SEPA)
        }
        return .success(.NATIONAL_SEPA)
    }
    
    func validateGenericTransfer(originAccount: AccountRepresentable, nationalTransferInput: SendMoneyGenericTransferInput) throws -> Result<ValidateAccountTransferRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func validateDeferredTransfer(originAcount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func validatePeriodicTransfer(originAcount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func validateGenericTransferOTP(originAccount: AccountRepresentable, nationalTransferInput: NationalTransferInputRepresentable, signature: SignatureRepresentable) throws -> Result<OTPValidationRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func validatePeriodicTransferOTP(signature: SignatureRepresentable, dataToken: String) throws -> Result<OTPValidationRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func validateDeferredTransferOTP(signature: SignatureRepresentable, dataToken: String) throws -> Result<OTPValidationRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func confirmGenericTransfer(originAccount: AccountRepresentable, nationalTransferInput: SendMoneyGenericTransferInput, otpValidation: OTPValidationRepresentable?, otpCode: String?) throws -> Result<TransferConfirmAccountRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func confirmDeferredTransfer(originAccount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput, otpValidation: OTPValidationRepresentable, otpCode: String) throws -> Result<Void, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func confirmPeriodicTransfer(originAccount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput, otpValidation: OTPValidationRepresentable, otpCode: String) throws -> Result<Void, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func getAllTransfers(accounts: [AccountRepresentable]?) throws -> Result<[TransferRepresentable], Error> {
        let response = try bsanTransferManager.getRecentRecipients()
        switch response {
        case .success(let transfers):
            return.success(transfers)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getAllTransfersReactive(accounts: [AccountRepresentable]?) -> AnyPublisher<[TransferRepresentable], Error> {
        return Future { promise in
            do {
                promise(try getAllTransfers(accounts: accounts))
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getTransferDetail(transfer: TransferRepresentable) throws -> Result<TransferRepresentable, Error> {
        return .success(transfer)
    }
    
    func loadAllUsualTransfers() -> AnyPublisher<[PayeeRepresentable], Error> {
        Future { promise in
            let parameters = GetPayeesParameters(recCunt: nil)
            do {
                let result = try self.bsanTransferManager.getPayees(parameters)
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func noSepaPayeeDetail(of alias: String, recipientType: String) -> AnyPublisher<NoSepaPayeeDetailRepresentable, Error> {
        return Empty()
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError> {
        let response = try bsanTransferManager.getChallenge(parameters: parameters)
        switch response {
        case .success(let transfers):
            return.success(transfers)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError> {
        let response = try self.bsanTransferManager.notifyDevice(parameters)
        switch response {
        case .success(let authorization):
            return .success(authorization)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getExchangeRatesReactive() -> AnyPublisher<[ExchangeRateRepresentable], Error> {
        Future { promise in
            do {
                let result = try self.getExchangeRates()
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getExchangeRates() throws -> Result<[ExchangeRateRepresentable], Error> {
        let result = try self.bsanTransferManager.getExchangeRates()
        switch result {
        case .success(let response):
            return .success(response.exchangeRates)
        case.failure(let error):
            return .failure(error)
        }
    }
}

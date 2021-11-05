//
//  TransferDataRepository.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 6/10/21.
//

import CoreDomain
import SANLegacyLibrary

struct TransfersDataRepository: PLTransfersRepository {
    
    let bsanTransferManager: PLTransfersManagerProtocol
    
    func getAccountForDebit() throws -> Result<[AccountRepresentable], Error> {
        let response = try bsanTransferManager.getAccountsForDebit()
        switch response {
        case .success(let accounts):
            return .success(accounts)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func checkTransactionAvailability(input: CheckTransactionAvailabilityInput) throws -> Result<CheckTransactionAvailabilityRepresentable, Error> {
        return .failure(ServiceError.unknown)
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
    
    func transferType(originAccount: AccountRepresentable, selectedCountry: String, selectedCurrerncy: String) throws -> Result<TransfersType, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func validateGenericTransfer(originAccount: AccountRepresentable, nationalTransferInput: SendMoneyGenericTransferInput) throws -> Result<ValidateAccountTransferRepresentable, Error> {
        guard let iban = nationalTransferInput.ibanRepresentable  else { return .failure(ServiceError.unknown) }
        let codBban = iban.checkDigits + iban.codBban.replacingOccurrences(of: " ", with: "")
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
                guard let errorDTO: ErrorDTO = error.getErrorBody() else { return .failure(NetworkProviderError.other)}
                return .failure(NetworkProviderError.error(NetworkProviderResponseError(code: errorDTO.errorCode2.rawValue, data: nil, headerFields: nil, error: error)))
            }
        } else {
            return .failure(ServiceError.unknown)
        }
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
    
    func confirmPeriodicTransfer(originAccount: AccountRepresentable, scheduledTransferInput: SendMoneyScheduledTransferInput, otpValidation: OTPValidationRepresentable, otpCode: String) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
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
}

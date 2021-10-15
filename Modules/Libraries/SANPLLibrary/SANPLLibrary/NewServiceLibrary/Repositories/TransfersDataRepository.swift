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
            return.success(accounts)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func transferType(originAccount: AccountRepresentable, selectedCountry: String, selectedCurrerncy: String) throws -> Result<TransfersType, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func validateGenericTransfer(originAccount: AccountRepresentable, nationalTransferInput: GenericTransferInputRepresentable) throws -> Result<ValidateAccountTransferRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func validateDeferredTransfer(originAcount: AccountRepresentable, scheduledTransferInput: ScheduledTransferInputRepresentable) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func validatePeriodicTransfer(originAcount: AccountRepresentable, scheduledTransferInput: ScheduledTransferInputRepresentable) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
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
    
    func confirmGenericTransfer(originAccount: AccountRepresentable, nationalTransferInput: GenericTransferInputRepresentable, otpValidation: OTPValidationRepresentable?, otpCode: String?) throws -> Result<TransferConfirmAccountRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func confirmDeferredTransfer(originAccount: AccountRepresentable, scheduledTransferInput: ScheduledTransferInputRepresentable, otpValidation: OTPValidationRepresentable, otpCode: String) throws -> Result<Void, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func confirmPeriodicTransfer(originAccount: AccountRepresentable, scheduledTransferInput: ScheduledTransferInputRepresentable, otpValidation: OTPValidationRepresentable, otpCode: String) throws -> Result<ValidateScheduledTransferRepresentable, Error> {
        return .failure(ServiceError.unknown)
    }
    
    func getAllTransfers(accounts: [AccountRepresentable]?) throws -> Result<[TransferRepresentable], Error> {
        return .failure(ServiceError.unknown)
    }
}

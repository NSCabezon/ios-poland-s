//
//  PLTransfersManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary
import CoreDomain

final class PLTransfersManagerAdapter {
    private let transferManager: PLTransfersManagerProtocol
    
    init(transferManager: PLTransfersManagerProtocol) {
        self.transferManager = transferManager
    }
}
 
extension PLTransfersManagerAdapter: BSANTransfersManager {
    func loadEmittedTransfers(account: AccountRepresentable, amountFrom: AmountRepresentable?, amountTo: AmountRepresentable?, dateFilter: DateFilter, pagination: PaginationRepresentable?) throws -> BSANResponse<TransferEmittedListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactions(forAccount account: AccountRepresentable, pagination: PaginationRepresentable?, filter: AccountTransferFilterInput) throws -> BSANResponse<AccountTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    

    func confirmRemoveSepaPayee(payeeId: String?, signatureWithTokenDTO: SignatureWithTokenDTO?) throws -> BSANResponse<SignatureWithTokenDTO?> {
        return BSANErrorResponse(nil)
    }

    func loadUsualTransfersOld() throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loadUsualTransfers() throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func sepaPayeeDetail(of alias: String, recipientType: String) throws -> BSANResponse<SepaPayeeDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateCreateSepaPayee(of alias: String, recipientType: FavoriteRecipientType, beneficiary: String, iban: IBANDTO, operationDate: Date) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateCreateSepaPayeeOTP(signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmCreateSepaPayee(otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateRemoveSepaPayee(ofAlias alias: String, payeeCode: String, recipientType: String, accountType: String) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmRemoveSepaPayee(signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateUpdateSepaPayee(payeeId: String?, payee: PayeeRepresentable?, newCurrencyDTO: CurrencyDTO?, newBeneficiaryBAOName: String?, newIban: IBANDTO?) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateUpdateSepaPayeeOTP(signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmUpdateSepaPayee(otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getUsualTransfers() throws -> BSANResponse<[SANLegacyLibrary.PayeeDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func validateUsualTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, usualTransferInput: UsualTransferInput, payee: PayeeRepresentable) throws -> BSANResponse<ValidateAccountTransferDTO> {
        return BSANErrorResponse(nil)
    }

    func confirmUsualTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, usualTransferInput: UsualTransferInput, payee: PayeeRepresentable, signatureDTO: SignatureDTO, trusteerInfo: TrusteerInfoDTO?) throws -> BSANResponse<TransferConfirmAccountDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getScheduledTransfers() throws -> BSANResponse<[String : TransferScheduledListDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func loadScheduledTransfers(account: SANLegacyLibrary.AccountDTO, amountFrom: AmountDTO?, amountTo: AmountDTO?, pagination: PaginationDTO?) throws -> BSANResponse<TransferScheduledListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getScheduledTransferDetail(account: SANLegacyLibrary.AccountDTO, transferScheduledDTO: TransferScheduledDTO) throws -> BSANResponse<TransferScheduledDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadScheduledTransferDetail(account: SANLegacyLibrary.AccountDTO, transferScheduledDTO: TransferScheduledDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func removeScheduledTransfer(accountDTO: SANLegacyLibrary.AccountDTO, orderIbanDTO: IBANDTO, transferScheduledDTO: TransferScheduledDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getHistoricalTransferCompleted() throws -> Bool {
        return false
    }
    
    func storeGetHistoricalTransferCompleted(_ completed: Bool) throws {}
    
    func validateScheduledTransfer(originAcount: SANLegacyLibrary.AccountDTO, scheduledTransferInput: ScheduledTransferInput) throws -> BSANResponse<ValidateScheduledTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateScheduledTransferOTP(signatureDTO: SignatureDTO, dataToken: String) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmScheduledTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, scheduledTransferInput: ScheduledTransferInput, otpValidationDTO: OTPValidationDTO, otpCode: String) throws -> BSANResponse<ValidateScheduledTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func modifyPeriodicTransferDetail(originAccountDTO: SANLegacyLibrary.AccountDTO, transferScheduledDTO: TransferScheduledDTO, transferScheduledDetailDTO: TransferScheduledDetailDTO) throws -> BSANResponse<ModifyPeriodicTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateModifyPeriodicTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, modifyScheduledTransferInput: ModifyScheduledTransferInput, modifyPeriodicTransferDTO: ModifyPeriodicTransferDTO, transferScheduledDetailDTO: TransferScheduledDetailDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmModifyPeriodicTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, modifyScheduledTransferInput: ModifyScheduledTransferInput, modifyPeriodicTransferDTO: ModifyPeriodicTransferDTO, transferScheduledDTO: TransferScheduledDTO, transferScheduledDetailDTO: TransferScheduledDetailDTO, otpValidationDTO: OTPValidationDTO, otpCode: String, scheduledDayType: ScheduledDayDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateDeferredTransfer(originAcount: SANLegacyLibrary.AccountDTO, scheduledTransferInput: ScheduledTransferInput) throws -> BSANResponse<ValidateScheduledTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateDeferredTransferOTP(signatureDTO: SignatureDTO, dataToken: String) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmDeferredTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, scheduledTransferInput: ScheduledTransferInput, otpValidationDTO: OTPValidationDTO, otpCode: String, trusteerInfo: TrusteerInfoDTO?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func modifyDeferredTransferDetail(originAccountDTO: SANLegacyLibrary.AccountDTO, transferScheduledDTO: TransferScheduledDTO, transferScheduledDetailDTO: TransferScheduledDetailDTO) throws -> BSANResponse<ModifyDeferredTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateModifyDeferredTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, modifyScheduledTransferInput: ModifyScheduledTransferInput, modifyDeferredTransferDTO: ModifyDeferredTransferDTO, transferScheduledDetailDTO: TransferScheduledDetailDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmModifyDeferredTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, modifyScheduledTransferInput: ModifyScheduledTransferInput, modifyDeferredTransferDTO: ModifyDeferredTransferDTO, transferScheduledDTO: TransferScheduledDTO, transferScheduledDetailDTO: TransferScheduledDetailDTO, otpValidationDTO: OTPValidationDTO, otpCode: String, trusteerInfo: TrusteerInfoDTO?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getEmittedTransfers() throws -> BSANResponse<[String : TransferEmittedListDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getEmittedTransferDetail(transferEmittedDTO: TransferEmittedDTO) throws -> BSANResponse<TransferEmittedDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadEmittedTransferDetail(transferEmittedDTO: TransferEmittedDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func transferType(originAccountDTO: SANLegacyLibrary.AccountDTO, selectedCountry: String, selectedCurrerncy: String) throws -> BSANResponse<TransfersType> {
        return BSANErrorResponse(nil)
    }
    
    func validateSwift(noSepaTransferInput: NoSEPATransferInput) throws -> BSANResponse<ValidationSwiftDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validationIntNoSEPA(noSepaTransferInput: NoSEPATransferInput, validationSwiftDTO: ValidationSwiftDTO?) throws -> BSANResponse<ValidationIntNoSepaDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validationOTPIntNoSEPA(validationIntNoSepaDTO: ValidationIntNoSepaDTO, noSepaTransferInput: NoSEPATransferInput) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmationIntNoSEPA(validationIntNoSepaDTO: ValidationIntNoSepaDTO, validationSwiftDTO: ValidationSwiftDTO?, noSepaTransferInput: NoSEPATransferInput, otpValidationDTO: OTPValidationDTO, otpCode: String, countryCode: String?, aliasPayee: String?, isNewPayee: Bool, trusteerInfo: TrusteerInfoDTO?) throws -> BSANResponse<ConfirmationNoSEPADTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadEmittedNoSepaTransferDetail(transferEmittedDTO: TransferEmittedDTO) throws -> BSANResponse<NoSepaTransferEmittedDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateGenericTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, nationalTransferInput: GenericTransferInputDTO) throws -> BSANResponse<ValidateAccountTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateGenericTransferOTP(originAccountDTO: SANLegacyLibrary.AccountDTO, nationalTransferInput: NationalTransferInput, signatureDTO: SignatureDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmGenericTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, nationalTransferInput: GenericTransferInputDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<TransferConfirmAccountDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmGenericTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, nationalTransferInput: GenericTransferInputDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?, trusteerInfo: TrusteerInfoDTO?) throws -> BSANResponse<TransferConfirmAccountDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateAccountTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, destinationAccountDTO: SANLegacyLibrary.AccountDTO, accountTransferInput: AccountTransferInput) throws -> BSANResponse<TransferAccountDTO> {
        return BSANOkResponse(nil)
    }
    
    func confirmAccountTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, destinationAccountDTO: SANLegacyLibrary.AccountDTO, accountTransferInput: AccountTransferInput, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmAccountTransfer(originAccountDTO: SANLegacyLibrary.AccountDTO, destinationAccountDTO: SANLegacyLibrary.AccountDTO, accountTransferInput: AccountTransferInput, signatureDTO: SignatureDTO, trusteerInfo: TrusteerInfoDTO?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func checkEntityAdhered(genericTransferInput: GenericTransferInputDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func checkTransferStatus(referenceDTO: ReferenceDTO) throws -> BSANResponse<CheckTransferStatusDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadAllUsualTransfers() throws -> BSANResponse<[SANLegacyLibrary.PayeeDTO]> {
        let parameters = GetPayeesParameters(recCunt: nil)
        let result = try self.transferManager.getPayees(parameters)
        switch result {
        case .success(let response):
            let payees =  response.map {
                PayeeDTOAdapter.adaptPayeeDTOtoCore(payeeDTO: $0)
            }
            return BSANOkResponse(payees)
            
        case .failure:
            return BSANErrorResponse(nil)
        }
    }
    
    func noSepaPayeeDetail(of alias: String, recipientType: String) throws -> BSANResponse<NoSepaPayeeDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateCreateNoSepaPayee(newAlias: String, newCurrency: CurrencyDTO?, noSepaPayeeDTO: NoSepaPayeeDTO?) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateCreateNoSepaPayeeOTP(signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmCreateNoSepaPayee(otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<ConfirmCreateNoSepaPayeeDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateUpdateNoSepaPayee(alias: String, noSepaPayeeDTO: NoSepaPayeeDTO?, newCurrencyDTO: CurrencyDTO?) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateUpdateNoSepaPayeeOTP(signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmUpdateNoSepaPayee(otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loadTransferSubTypeCommissions(originAccount: SANLegacyLibrary.AccountDTO, destinationAccount: IBANDTO, amount: AmountDTO, beneficiary: String, concept: String) throws -> BSANResponse<TransferSubTypeCommissionDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateCreateSepaPayee(alias: String, recipientType: FavoriteRecipientType?, beneficiary: String, iban: IBANDTO?, serviceType: String?, contractType: String?, accountIdType: String?, accountId: String?, streetName: String?, townName: String?, location: String?, country: String?, operationDate: Date?) throws -> BSANResponse<SignatureWithTokenDTO?> {
        return BSANErrorResponse(nil)
    }
}

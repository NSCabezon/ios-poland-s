//
//  PLBizumManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLBizumManagerAdapter {}
 
extension PLBizumManagerAdapter: BSANBizumManager {

    func checkPayment(defaultXPAN: String) throws -> BSANResponse<BizumCheckPaymentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getOrganizations(_ input: BizumGetOrganizationsInputParams) throws -> BSANResponse<BizumOrganizationsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func checkPayment() throws -> BSANResponse<BizumCheckPaymentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getContacts(_ input: BizumGetContactsInputParams) throws -> BSANResponse<BizumGetContactsDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateMoneyTransfer(_ input: BizumValidateMoneyTransferInputParams) throws -> BSANResponse<BizumValidateMoneyTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateMoneyTransferMulti(_ input: BizumValidateMoneyTransferMultiInputParams) throws -> BSANResponse<BizumValidateMoneyTransferMultiDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getSignPositions() throws -> BSANResponse<BizumSignPositionsDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateMoneyTransferOTP(_ input: BizumValidateMoneyTransferOTPInputParams) throws -> BSANResponse<BizumValidateMoneyTransferOTPDTO> {
        return BSANErrorResponse(nil)
    }
    
    func signRefundMoney(with input: BizumSignRefundMoneyInputParams) throws -> BSANResponse<BizumValidateMoneyTransferOTPDTO> {
        return BSANErrorResponse(nil)
    }
    
    func moneyTransferOTP(_ input: BizumMoneyTransferOTPInputParams) throws -> BSANResponse<BizumMoneyTransferOTPDTO> {
        return BSANErrorResponse(nil)
    }
    
    func moneyTransferOTPMulti(_ input: BizumMoneyTransferOTPMultiInputParams) throws -> BSANResponse<BizumTransferInfoDTO> {
        return BSANErrorResponse(nil)
    }
    
    func inviteNoClientOTP(_ input: BizumInviteNoClientOTPInputParams) throws -> BSANResponse<BizumInviteNoClientDTO> {
        return BSANErrorResponse(nil)
    }
    
    func inviteNoClient(_ input: BizumInviteNoClientInputParams) throws -> BSANResponse<BizumInviteNoClientDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getOperations(_ input: BizumOperationsInputParams) throws -> BSANResponse<BizumOperationListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getListMultipleOperations(_ input: BizumOperationListMultipleInputParams) throws -> BSANResponse<BizumOperationMultiListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getListMultipleDetailOperation(_ input: BizumOperationMultipleListDetailInputParams) throws -> BSANResponse<BizumOperationMultipleListDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getMultimediaUsers(_ input: BizymMultimediaUsersInputParams) throws -> BSANResponse<BizumGetMultimediaContactsDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getMultimediaContent(_ input: BizumMultimediaContentInputParams) throws -> BSANResponse<BizumGetMultimediaContentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func sendImageText(_ input: BizumSendMultimediaInputParams) throws -> BSANResponse<BizumTransferInfoDTO> {
        return BSANErrorResponse(nil)
    }
    
    func sendImageTextMulti(_ input: BizumSendImageTextMultiInputParams) throws -> BSANResponse<BizumTransferInfoDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateMoneyRequest(_ input: BizumValidateMoneyRequestInputParams) throws -> BSANResponse<BizumValidateMoneyRequestDTO> {
        return BSANErrorResponse(nil)
    }
    
    func moneyRequest(_ input: BizumMoneyRequestInputParams) throws -> BSANResponse<BizumMoneyRequestDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateMoneyRequestMulti(_ input: BizumValidateMoneyRequestMultiInputParams) throws -> BSANResponse<BizumValidateMoneyRequestMultiDTO> {
        return BSANErrorResponse(nil)
    }
    
    func moneyRequestMulti(_ input: BizumMoneyRequestMultiInputParams) throws -> BSANResponse<BizumMoneyRequestMultiDTO> {
        return BSANErrorResponse(nil)
    }
    
    func cancelPendingTransfer(_ input: BizumCancelNotRegisterInputParam) throws -> BSANResponse<BizumResponseInfoDTO> {
        return BSANErrorResponse(nil)
    }
    
    func refundMoneyRequest(_ input: BizumRefundMoneyRequestInputParams) throws -> BSANResponse<BizumRefundMoneyResponseDTO> {
        return BSANErrorResponse(nil)
    }
    
    func acceptRequestMoneyTransferOTP(_ input: BizumAcceptRequestMoneyTransferOTPInputParams) throws -> BSANResponse<BizumMoneyTransferOTPDTO> {
        return BSANErrorResponse(nil)
    }

    func getRedsysUserDocument(input: BizumGetRedsysDocumentInputParams) throws -> BSANResponse<BizumRedsysDocumentDTO> {
        return BSANErrorResponse(nil)
    }
}

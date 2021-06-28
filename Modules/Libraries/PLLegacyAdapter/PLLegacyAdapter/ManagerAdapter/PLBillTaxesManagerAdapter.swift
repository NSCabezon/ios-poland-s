//
//  PLBillTaxesManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import Foundation
import SANLegacyLibrary

final class PLBillTaxesManagerAdapter {
}
 
extension PLBillTaxesManagerAdapter: BSANBillTaxesManager {
    func cancelDirectBilling(account: AccountDTO, bill: BillDTO, enableBillAndTaxesRemedy: Bool) throws -> BSANResponse<GetCancelDirectBillingDTO> {
        return BSANErrorResponse(nil)
    }

    func duplicateBill(account: AccountDTO, bill: BillDTO, enableBillAndTaxesRemedy: Bool) throws -> BSANResponse<DuplicateBillDTO> {
        return BSANErrorResponse(nil)
    }

    func confirmDuplicateBill(account: AccountDTO, bill: BillDTO, signature: SignatureDTO, enableBillAndTaxesRemedy: Bool) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }

    func confirmReceiptReturn(account: AccountDTO, bill: BillDTO, billDetail: BillDetailDTO, signature: SignatureDTO, enableBillAndTaxesRemedy: Bool) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }

    func downloadPdfBill(account: AccountDTO, bill: BillDTO, enableBillAndTaxesRemedy: Bool) throws -> BSANResponse<DocumentDTO> {
        return BSANErrorResponse(nil)
    }

    func billAndTaxesDetail(of account: AccountDTO, bill: BillDTO, enableBillAndTaxesRemedy: Bool) throws -> BSANResponse<BillDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateBillAndTaxes(accountDTO: AccountDTO, barCode: String) throws -> BSANResponse<PaymentBillTaxesDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmationBillAndTaxes(chargeAccountDTO: AccountDTO, paymentBillTaxesDTO: PaymentBillTaxesDTO, billAndTaxesTokenDTO: BillAndTaxesTokenDTO, directDebit: Bool) throws -> BSANResponse<PaymentBillTaxesConfirmationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func consultSignatureBillAndTaxes(chargeAccountDTO: AccountDTO, directDebit: Bool, amountDTO: AmountDTO) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmationSignatureBillAndTaxes(signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<BillAndTaxesTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func consultFormats(of account: AccountDTO, emitterCode: String, productIdentifier: String, collectionTypeCode: String, collectionCode: String) throws -> BSANResponse<ConsultTaxCollectionFormatsDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadBills(of account: AccountDTO, from fromDate: DateModel, to toDate: DateModel, status: BillListStatus) throws -> BSANResponse<BillListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadBills(of account: AccountDTO, pagination: PaginationDTO?, from fromDate: DateModel, to toDate: DateModel, status: BillListStatus) throws -> BSANResponse<BillListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func deleteBillList() throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func billAndTaxesDetail(of account: AccountDTO, bill: BillDTO) throws -> BSANResponse<BillDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func cancelDirectBilling(account: AccountDTO, bill: BillDTO) throws -> BSANResponse<GetCancelDirectBillingDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmCancelDirectBilling(account: AccountDTO, bill: BillDTO, signature: SignatureDTO, getCancelDirectBillingDTO: GetCancelDirectBillingDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func duplicateBill(account: AccountDTO, bill: BillDTO) throws -> BSANResponse<DuplicateBillDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmDuplicateBill(account: AccountDTO, bill: BillDTO, signature: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmReceiptReturn(account: AccountDTO, bill: BillDTO, billDetail: BillDetailDTO, signature: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmChangeDirectDebit(account: AccountDTO, bill: BillDTO, signature: SignatureWithTokenDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func downloadPdfBill(account: AccountDTO, bill: BillDTO) throws -> BSANResponse<DocumentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateChangeMassiveDirectDebitsAccount(originAccount: AccountDTO, destinationAccount: AccountDTO) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmChangeMassiveDirectDebitsAccount(originAccount: AccountDTO, signature: SignatureWithTokenDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loadFutureBills(account: AccountDTO, status: String, numberOfElements: Int, page: Int) throws -> BSANResponse<AccountFutureBillListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func emittersConsult(params: EmittersConsultParamsDTO) throws -> BSANResponse<EmittersConsultDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadBillCollectionList(emitterCode: String, account: AccountDTO) throws -> BSANResponse<BillCollectionListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadBillCollectionList(emitterCode: String, account: AccountDTO, pagination: PaginationDTO?) throws -> BSANResponse<BillCollectionListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func emittersPaymentConfirmation(account: AccountDTO, signature: SignatureDTO, amount: AmountDTO, emitterCode: String, productIdentifier: String, collectionTypeCode: String, collectionCode: String, billData: [String]) throws -> BSANResponse<BillEmittersPaymentConfirmationDTO> {
        return BSANErrorResponse(nil)
    }
    
}

//
//  PLFundsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import CoreDomain

final class PLFundsManagerAdapter {}
 
extension PLFundsManagerAdapter: BSANFundsManager {
    func getFundTransactions(forFund fund: FundDTO, dateFilter: DateFilter?, pagination: PaginationDTO?) throws -> BSANResponse<FundTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getFundDetail(forFund fundDTO: FundDTO) throws -> BSANResponse<FundDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getFundTransactionDetail(forFund fundDTO: FundDTO, fundTransactionDTO: FundTransactionDTO) throws -> BSANResponse<FundTransactionDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateFundSubscriptionAmount(fundDTO: FundDTO, amountDTO: AmountDTO) throws -> BSANResponse<FundSubscriptionDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateFundSubscriptionShares(fundDTO: FundDTO, sharesNumber: Decimal) throws -> BSANResponse<FundSubscriptionDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmFundSubscriptionAmount(fundDTO: FundDTO, amountDTO: AmountDTO, fundSubscriptionDTO: FundSubscriptionDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<FundSubscriptionConfirmDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmFundSubscriptionShares(fundDTO: FundDTO, sharesNumber: Decimal, fundSubscriptionDTO: FundSubscriptionDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<FundSubscriptionConfirmDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateFundTransferTotal(originFundDTO: FundDTO, destinationFundDTO: FundDTO) throws -> BSANResponse<FundTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateFundTransferPartialByAmount(originFundDTO: FundDTO, destinationFundDTO: FundDTO, amountDTO: AmountDTO) throws -> BSANResponse<FundTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateFundTransferPartialByShares(originFundDTO: FundDTO, destinationFundDTO: FundDTO, sharesNumber: Decimal) throws -> BSANResponse<FundTransferDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmFundTransferTotal(originFundDTO: FundDTO, destinationFundDTO: FundDTO, fundTransferDTO: FundTransferDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmFundTransferPartialByAmount(originFundDTO: FundDTO, destinationFundDTO: FundDTO, fundTransferDTO: FundTransferDTO, amountDTO: AmountDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmFundTransferPartialByShares(originFundDTO: FundDTO, destinationFundDTO: FundDTO, fundTransferDTO: FundTransferDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
}

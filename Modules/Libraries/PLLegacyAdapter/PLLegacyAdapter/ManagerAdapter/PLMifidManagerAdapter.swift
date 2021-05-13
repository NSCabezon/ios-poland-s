//
//  PLMifidManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLMifidManagerAdapter {}
 
extension PLMifidManagerAdapter: BSANMifidManager {
    func getMifidIndicator(contractDTO: ContractDTO) throws -> BSANResponse<MifidIndicatorDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getMifidClauses(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO, tradedSharesCount: String, transferMode: String) throws -> BSANResponse<MifidDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCounterValueDetail(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO) throws -> BSANResponse<RMVDetailDTO> {
        return BSANErrorResponse(nil)
    }
}

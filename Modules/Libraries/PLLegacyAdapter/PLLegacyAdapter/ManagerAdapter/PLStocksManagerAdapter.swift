//
//  PLStocksManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLStocksManagerAdapter {}
 
extension PLStocksManagerAdapter: BSANStocksManager {
    func getStocks(stockAccountDTO: StockAccountDTO, pagination: PaginationDTO?) throws -> BSANResponse<StockListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAllStocks(stockAccountDTO: StockAccountDTO) throws -> BSANResponse<StockListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getStocksQuotes(searchString: String, pagination: PaginationDTO?) throws -> BSANResponse<StockQuotesListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getQuoteDetail(stockQuoteDTO: StockQuoteDTO) throws -> BSANResponse<StockQuoteDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getOrdenes(stockAccountDTO: StockAccountDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<OrderListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func deleteStockOrders() throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getOrderDetail(order: OrderDTO, stockAccountDTO: StockAccountDTO) throws -> BSANResponse<OrderDetailDTO?> {
        return BSANErrorResponse(nil)
    }
    
    func removeOrderDetail(order: OrderDTO, stockAccountDTO: StockAccountDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getStocksQuoteIBEXSAN() throws -> BSANResponse<StockQuotesListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func setCancellationOrder(orderDTO: OrderDTO, signatureDTO: SignatureDTO, stockAccountDTO: StockAccountDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateBuyStockLimited(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO, stockLimitedOperationInput: StockLimitedOperationInput) throws -> BSANResponse<StockDataBuySellDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateBuyStockTypeOrder(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO, stockTypeOrderOperationInput: StockTypeOrderOperationInput) throws -> BSANResponse<StockDataBuySellDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmBuyStockLimited(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO, stockLimitedOperationInput: StockLimitedOperationInput, signatureDTO: SignatureDTO) throws -> BSANResponse<StockOperationDataConfirmDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmBuyStockTypeOrder(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO, stockTypeOrderOperationInput: StockTypeOrderOperationInput, signatureDTO: SignatureDTO) throws -> BSANResponse<StockOperationDataConfirmDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateSellStockLimited(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO, stockLimitedOperationInput: StockLimitedOperationInput) throws -> BSANResponse<StockDataBuySellDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateSellStockTypeOrder(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO, stockTypeOrderOperationInput: StockTypeOrderOperationInput) throws -> BSANResponse<StockDataBuySellDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmSellStockLimited(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO, stockLimitedOperationInput: StockLimitedOperationInput, signatureDTO: SignatureDTO) throws -> BSANResponse<StockOperationDataConfirmDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmSellStockTypeOrder(stockAccountDTO: StockAccountDTO, stockQuoteDTO: StockQuoteDTO, stockTypeOrderOperationInput: StockTypeOrderOperationInput, signatureDTO: SignatureDTO) throws -> BSANResponse<StockOperationDataConfirmDTO> {
        return BSANErrorResponse(nil)
    }
    
}

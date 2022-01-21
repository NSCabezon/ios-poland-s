//
//  PLPortfoliosPBManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import CoreDomain

final class PLPortfoliosPBManagerAdapter {}

extension PLPortfoliosPBManagerAdapter: BSANPortfoliosPBManager {
    
    public func getPortfoliosNotManaged() throws -> BSANResponse<[PortfolioDTO]> {
        return BSANOkResponse([PortfolioDTO]())
    }
    
    public func getPortfoliosManaged() throws -> BSANResponse<[PortfolioDTO]> {
        return BSANOkResponse([PortfolioDTO]())
    }
    
    public func getRVPortfoliosNotManaged() throws -> BSANResponse<[PortfolioDTO]> {
        return BSANOkResponse([PortfolioDTO]())
    }
    
    public func getRVPortfoliosManaged() throws -> BSANResponse<[PortfolioDTO]> {
        return BSANOkResponse([PortfolioDTO]())
    }
    
    public func getRVManagedStockAccountList() throws -> BSANResponse<[StockAccountDTO]> {
        return BSANOkResponse([StockAccountDTO]())
    }
    
    public func getRVNotManagedStockAccountList() throws -> BSANResponse<[StockAccountDTO]> {
        return BSANOkResponse([StockAccountDTO]())
    }
    
    public func loadPortfoliosPb() throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func loadPortfoliosSelect() throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func resetPortfolios() {}
    
    public func loadVariableIncomePortfolioPb() throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func loadVariableIncomePortfolioSelect() throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func deletePortfoliosProducts() throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func getPortfolioProducts(portfolioPBDTO: PortfolioDTO) throws -> BSANResponse<[PortfolioProductDTO]> {
        return BSANOkResponse([PortfolioProductDTO]())
    }
    
    public func getHolderDetail(portfolioPBDTO: PortfolioDTO) throws -> BSANResponse<[HolderDTO]> {
        return BSANOkResponse([HolderDTO]())
    }
    
    public func getPortfolioProductTransactionDetail(transactionDTO: PortfolioTransactionDTO) throws -> BSANResponse<PortfolioTransactionDetailDTO> {
        return BSANOkResponse(PortfolioTransactionDetailDTO())
    }
    
    public func getPortfolioProductTransactions(portfolioProductPBDTO: PortfolioProductDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<PortfolioTransactionsListDTO> {
        return BSANOkResponse(PortfolioTransactionsListDTO())
    }
}

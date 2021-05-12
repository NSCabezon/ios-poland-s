//
//  PLAccountsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLAccountsManagerAdapter {}

extension PLAccountsManagerAdapter: BSANAccountsManager {
    func getAllAccounts() throws -> BSANResponse<[AccountDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountDetail(forAccount account: AccountDTO) throws -> BSANResponse<AccountDetailDTO> {
        return BSANOkResponse(nil)
    }
    
    func getAllAccountTransactions(forAccount account: AccountDTO, dateFilter: DateFilter?) throws -> BSANResponse<AccountTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactions(forAccount account: AccountDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<AccountTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactions(forAccount account: AccountDTO, pagination: PaginationDTO?, dateFilter: DateFilter?, cached: Bool) throws -> BSANResponse<AccountTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactions(forAccount account: AccountDTO, pagination: PaginationDTO?, filter: AccountTransferFilterInput) throws -> BSANResponse<AccountTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactionDetail(from transactionDTO: AccountTransactionDTO) throws -> BSANResponse<AccountTransactionDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func checkAccountMovementPdf(accountDTO: AccountDTO, accountTransactionDTO: AccountTransactionDTO) throws -> BSANResponse<DocumentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccount(fromOldContract oldContract: ContractDTO?) throws -> BSANResponse<AccountDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccount(fromIBAN iban: IBANDTO?) throws -> BSANResponse<AccountDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountEasyPay() throws -> BSANResponse<[AccountEasyPayDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func changeAccountAlias(accountDTO: AccountDTO, newAlias: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func changeMainAccount(accountDTO: AccountDTO, newMain: Bool) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getWithholdingList(iban: String, currency: String) throws -> BSANResponse<WithholdingListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountMovements(params: AccountMovementListParams, account: String) throws -> BSANResponse<AccountMovementListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountFutureBills(params: AccountFutureBillParams) throws -> BSANResponse<AccountFutureBillListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactionCategory(params: TransactionCategorizerInputParams) throws -> BSANResponse<TransactionCategorizerDTO> {
        return BSANErrorResponse(nil)
    }
}

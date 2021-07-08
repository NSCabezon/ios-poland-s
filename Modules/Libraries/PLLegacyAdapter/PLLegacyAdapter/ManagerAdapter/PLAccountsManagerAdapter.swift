//
//  PLAccountsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary

final class PLAccountsManagerAdapter {

    private let accountManager: PLAccountManagerProtocol
    private let bsanDataProvider: BSANDataProvider

    init(accountManager: PLAccountManagerProtocol, bsanDataProvider: BSANDataProvider) {
        self.accountManager = accountManager
        self.bsanDataProvider = bsanDataProvider
    }
}

extension PLAccountsManagerAdapter: BSANAccountsManager {
    func getAllAccounts() throws -> BSANResponse<[SANLegacyLibrary.AccountDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountDetail(forAccount account: SANLegacyLibrary.AccountDTO) throws -> BSANResponse<SANLegacyLibrary.AccountDetailDTO> {
        guard let accountNumber = account.contractDescription,
              let sessionData = try? self.bsanDataProvider.getSessionData(),
              let plAccount = sessionData.globalPositionDTO?.accounts?.filter({$0.number == accountNumber}).first else {
            return BSANErrorResponse(nil)
        }

        let accountDetailsParameters = AccountDetailsParameters(includeDetails: true, includePermissions: true)
        let accountDetails = try self.accountManager.getDetails(accountNumber: accountNumber, parameters: accountDetailsParameters).get()
        let swiftBranches = try? self.accountManager.getSwiftBranches(accountNumber: accountNumber).get()

        let adaptedAccountDetail = AccountDetailsDTOAdapter.adaptPLAccountDetailsToAccountDetails(accountDetails, account: plAccount, swiftBranches: swiftBranches)
        return BSANOkResponse(adaptedAccountDetail)
    }
    
    func getAllAccountTransactions(forAccount account: SANLegacyLibrary.AccountDTO, dateFilter: DateFilter?) throws -> BSANResponse<AccountTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactions(forAccount account: SANLegacyLibrary.AccountDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<AccountTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactions(forAccount account: SANLegacyLibrary.AccountDTO, pagination: PaginationDTO?, dateFilter: DateFilter?, cached: Bool) throws -> BSANResponse<AccountTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactions(forAccount account: SANLegacyLibrary.AccountDTO, pagination: PaginationDTO?, filter: AccountTransferFilterInput) throws -> BSANResponse<AccountTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountTransactionDetail(from transactionDTO: AccountTransactionDTO) throws -> BSANResponse<AccountTransactionDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func checkAccountMovementPdf(accountDTO: SANLegacyLibrary.AccountDTO, accountTransactionDTO: AccountTransactionDTO) throws -> BSANResponse<DocumentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccount(fromOldContract oldContract: ContractDTO?) throws -> BSANResponse<SANLegacyLibrary.AccountDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccount(fromIBAN iban: IBANDTO?) throws -> BSANResponse<SANLegacyLibrary.AccountDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAccountEasyPay() throws -> BSANResponse<[AccountEasyPayDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func changeAccountAlias(accountDTO: SANLegacyLibrary.AccountDTO, newAlias: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func changeMainAccount(accountDTO: SANLegacyLibrary.AccountDTO, newMain: Bool) throws -> BSANResponse<Void> {
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

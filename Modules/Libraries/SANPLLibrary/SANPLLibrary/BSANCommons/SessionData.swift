//
//  SessionData.swift
//  SANPLLibrary
//

import Foundation

public class SessionData: Codable {
    
    public var loggedUserDTO: UserDTO
    public var globalPositionDTO: GlobalPositionDTO?
    public var loanInfo: LoanInfo = LoanInfo()
    public var fundInfo: FundInfo = FundInfo()
    public var accountInfo: AccountInfo = AccountInfo()
    public var creditCardRepaymentInfo: CreditCardRepaymentInfo = CreditCardRepaymentInfo()
    public var helpCenterInfo: HelpCenterInfo = HelpCenterInfo()
    public var helpQuestionsInfo: HelpQuestionsInfo = HelpQuestionsInfo()
    public var cardsTransactions: [String : CardTransactionListDTO] = [:]
    public var cardTransactionsPagination: [String : TransactionsLinksDTO] = [:]
    public var customer: CustomerDTO?
    public var loginInfo: LoginInfoDTO?

    public init(_ userDTO: UserDTO) {
        self.loggedUserDTO = userDTO
    }
    
    public func updateSessionData(_ isPB: Bool) {
        loggedUserDTO.isPB = isPB
    }
}

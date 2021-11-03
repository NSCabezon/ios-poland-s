//
//  PLCreditCardRepaymentManagerMock.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 13/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SANPLLibrary
import Commons
import PLCommons

final class PLCreditCardRepaymentManagerMock: PLCreditCardRepaymentManagerProtocol {
    
    private static let bundle = Bundle(for: GetAccountsUseCaseTests.self)
    
    @DecodeFile(name: "getAccountForCreditSuccessResponse", bundle: bundle)
    public var ccrAccountsForCredit: [CCRAccountDTO]
    
    @DecodeFile(name: "getAccountForDebitSuccessResponse", bundle: bundle)
    public var ccrAccountsForDebit: [CCRAccountDTO]
    
    @DecodeFile(name: "getGlobalPositionSuccessResponse", bundle: bundle)
    public var globalPosition: SANPLLibrary.GlobalPositionDTO
    
    @DecodeFile(name: "sendCreditCardSuccessResponse", bundle: bundle)
    public var ccrSummaryDTO: AcceptDomesticTransferSummaryDTO
    
    var forceError = false
    var maxCardLimit: Int = .max
    
    func getCards() throws -> Result<[CCRCardDTO], NetworkProviderError> {
        guard !forceError else { return .failure(.other) }
        guard let gpCards = globalPosition.cards else { return .failure(.other) }
        let accounts = ccrAccountsForCredit
        
        let cards = gpCards
            .filter { $0.type == "CREDIT"}
            .map { card -> CCRCardDTO in
                let account = accounts.first { card.relatedAccount == $0.number }
                return CCRCardDTO.mapFromCardDTO(card, account: account)
            }
            .prefix(maxCardLimit)
        
        return .success(Array(cards))
    }
    
    func getAccountsForDebit() throws -> Result<[CCRAccountDTO], NetworkProviderError> {
        guard !forceError else { return .failure(.other) }
            
        return .success(ccrAccountsForDebit)
    }
    
    func getAccountsForCredit() throws -> Result<[CCRAccountDTO], NetworkProviderError> {
        guard !forceError else { return .failure(.other) }
            
        return .success(ccrAccountsForCredit)
    }
    
    func sendRepayment(_ parameters: AcceptDomesticTransactionParameters) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        guard !forceError else { return .failure(.other) }
        
        return .success(ccrSummaryDTO)
    }
}

//
//  FakePLManagers.swift
//  LoanSchedule_Example
//
//  Created by 187452 on 24/09/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import LoanSchedule
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary

final class FakePLManagersProvider: PLManagersProviderProtocol {
    
    init(mockData: LoanScheduleMockData) {
        self.mockData = mockData
    }
    
    private let mockData: LoanScheduleMockData
    
    func getAccountsManager() -> PLAccountManagerProtocol {
        fatalError()
    }
    
    func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol {
        fatalError()
    }
    
    func getCustomerManager() -> PLCustomerManagerProtocol {
        fatalError()
    }
    
    func getLoginManager() -> PLLoginManagerProtocol {
        fatalError()
    }
    
    func getBLIKManager() -> PLBLIKManagerProtocol {
        fatalError()
    }
    
    func getCreditCardRepaymentManager() -> PLCreditCardRepaymentManagerProtocol {
        fatalError()
    }
    
    func getHelpCenterManager() -> PLHelpCenterManagerProtocol {
        fatalError()
    }
    
    func getTrustedDeviceManager() -> PLTrustedDeviceManager {
        fatalError()
    }
    
    func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol {
        FakeGlobalPositionManager()
    }
    
    func getCardsManager() -> PLCardsManagerProtocol {
        fatalError()
    }
    
    func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol {
        fatalError()
    }
    
    func getLoanScheduleManager() -> PLLoanScheduleManagerProtocol {
        FakeLoanScheduleManager(mockData: mockData)
    }
}

final class FakeLoanScheduleManager: PLLoanScheduleManagerProtocol {
    
    init(mockData: LoanScheduleMockData) {
        self.mockData = mockData
    }
    
    private let mockData: LoanScheduleMockData
    
    func getLoanSchedule(_ parameters: LoanScheduleParameters) throws -> Result<LoanScheduleDTO, NetworkProviderError> {
        if let loanScheduleDTO = mockData.loanScheduleDTO {
            return .success(loanScheduleDTO)
        } else {
            return .failure(.other)
        }
    }
    
}

final class FakeBSANDataProvider: BSANDataProviderProtocol {
    
    func getAuthCredentialsProvider() throws -> AuthCredentialsProvider {
        return SANPLLibrary.AuthCredentials(login: nil, userId: nil, userCif: nil, companyContext: nil, accessTokenCredentials: nil, trustedDeviceTokenCredentials: nil)
    }
    
    public func getLanguageISO() throws -> String {
        return "pl"
    }
    
    public func getDialectISO() throws -> String {
        return "PL"
    }
    
    public func store(creditCardRepaymentAccounts accounts: [CCRAccountDTO]) {
        
    }
    
    public func store(creditCardRepaymentCards cards: [CCRCardDTO]) {
        
    }
    
    public func getCreditCardRepaymentInfo() -> CreditCardRepaymentInfo? {
        return nil
    }
    
    public func cleanCreditCardRepaymentInfo() {
        
    }
}

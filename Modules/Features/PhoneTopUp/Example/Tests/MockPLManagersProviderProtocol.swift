//
//  MockPLManagersProviderProtocol.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 10/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SANPLLibrary
@testable import IDZSwiftCommonCrypto

final class MockPLManagersProvider: PLManagersProviderProtocol {
    
    var phoneTopUpManager = MockPLPhoneTopUpManager()
    
    func getDepositsManager() -> PLDepositManagerProtocol {
        fatalError()
    }
    
    func getFundsManager() -> PLFundManagerProtocol {
        fatalError()
    }
    
    func getPhoneTopUpManager() -> PLPhoneTopUpManagerProtocol {
        return phoneTopUpManager
    }
    
    func getHistoryManager() -> PLHistoryManagerProtocol {
        fatalError()
    }
    
    func getExpensesChartManager() -> PLExpensesChartManagerProtocol {
        fatalError()
    }
    
    func getSplitPaymentManager() -> PLSplitPaymentManagerProtocol {
        fatalError()
    }
}

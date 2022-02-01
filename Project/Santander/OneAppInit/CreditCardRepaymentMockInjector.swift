//
//  CreditCardRepaymentMockInjector.swift
//  Santander
//
//  Created by 186493 on 18/06/2021.
//

import Foundation
import CoreFoundationLib
import CreditCardRepayment
import SANPLLibrary
import SANLegacyLibrary
import CoreFoundationLib

// Temporary class
final class CreditCardRepaymentMockInjector {
    
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    internal init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
    }
    
    func injectMockForCreditCardRepayment(multipleChoices: Bool) {
        let mock = CreditCardRepaymentManagerMockData(multipleChoices: multipleChoices)
        
        if let dataProvider = dependenciesEngine.resolve(for: BSANDataProviderProtocol.self) as? SANPLLibrary.BSANDataProvider {
            let sessionData = try? dataProvider.getSessionData()
            let userDTO = sessionData?.loggedUserDTO ?? UserDTO(loginType: .U, login: "CreditCardRepaymentMockUser")
            dataProvider.createSessionData(userDTO)
            dataProvider.store(mock.globalPosition)
            dataProvider.store(creditCardRepaymentDebitAccounts: mock.ccrAccountsForDebit)
            dataProvider.store(creditCardRepaymentCreditAccounts: mock.ccrAccountsForCredit)
            dataProvider.store(creditCardRepaymentCards: [])
        }
    }
}

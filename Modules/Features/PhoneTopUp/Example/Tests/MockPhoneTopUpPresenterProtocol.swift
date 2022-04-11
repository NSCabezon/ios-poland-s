//
//  MockPhoneTopUpPresenterProtocol.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 09/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import PLCommons
@testable import PhoneTopUp

final class MockPhoneTopUpFormPresenterProtocol: PhoneTopUpFormPresenterProtocol {
    var view: PhoneTopUpFormViewProtocol?
    
    func viewDidLoad() {
    }
    
    func didSelectBack() {
        fatalError()
    }
    
    func didSelectClose() {
        fatalError()
    }
    
    func didSelectChangeAccount() {
        fatalError()
    }
    
    func didTouchContactsButton() {
        fatalError()
    }
    
    func didInputPartialPhoneNumber(_ number: String) {
        fatalError()
    }
    
    func didInputFullPhoneNumber(_ number: String) {
        fatalError()
    }
    
    func didSelectTopUpAmount(_ amount: TopUpAmount) {
        fatalError()
    }
    
    func didTouchContinueButton() {
        fatalError()
    }
    
    func didTouchOperatorSelectionButton() {
        fatalError()
    }
    
    func didTouchTermsAndConditionsCheckBox() {
        fatalError()
    }
    
    func didSelectAccount(withAccountNumber accountNumber: String) {
        fatalError()
    }
    
    func mobileContactsDidSelectContact(_ contact: MobileContact) {
        fatalError()
    }
    
    func mobileContactDidSelectCloseProcess() {
        fatalError()
    }
    
    func didSelectOperator(_ gsmOperator: Operator) {
        fatalError()
    }
}

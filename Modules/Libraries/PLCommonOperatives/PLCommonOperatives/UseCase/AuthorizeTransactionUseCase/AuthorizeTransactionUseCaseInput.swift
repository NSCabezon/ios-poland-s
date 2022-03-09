//
//  AuthorizeTransactionUseCaseInput.swift
//  PhoneTopUp
//
//  Created by 188216 on 04/03/2022.
//

import Foundation
import SANPLLibrary

public struct AuthorizeTransactionUseCaseInput {
    public let sendMoneyConfirmationInput: GenericSendMoneyConfirmationInput
    public let partialNotifyDeviceInput: PartialNotifyDeviceInput
    
    public init(sendMoneyConfirmationInput: GenericSendMoneyConfirmationInput, partialNotifyDeviceInput: PartialNotifyDeviceInput) {
        self.sendMoneyConfirmationInput = sendMoneyConfirmationInput
        self.partialNotifyDeviceInput = partialNotifyDeviceInput
    }
}

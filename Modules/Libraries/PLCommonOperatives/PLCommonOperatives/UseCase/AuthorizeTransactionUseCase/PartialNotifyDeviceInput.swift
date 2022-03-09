//
//  PartialNotifyDeviceInput.swift
//  PhoneTopUp
//
//  Created by 188216 on 04/03/2022.
//

import Foundation

import Foundation
import CoreDomain
import SANPLLibrary

public struct PartialNotifyDeviceInput {
    public let softwareTokenType: String?
    public let notificationSchemaId: String
    public let alias: String
    public let iban: IBANRepresentable
    public let amount: AmountRepresentable
    public let variables: [String]?
    
    public init(softwareTokenType: String?,
                notificationSchemaId: String,
                alias: String,
                iban: IBANRepresentable,
                amount: AmountRepresentable,
                variables: [String]? = nil) {
        self.softwareTokenType = softwareTokenType
        self.notificationSchemaId = notificationSchemaId
        self.alias = alias
        self.iban = iban
        self.amount = amount
        self.variables = variables
    }
}

public extension NotifyDeviceInput {
    init(partialInput: PartialNotifyDeviceInput, challenge: String) {
        self.init(challenge: challenge,
                  softwareTokenType: partialInput.softwareTokenType,
                  notificationSchemaId: partialInput.notificationSchemaId,
                  alias: partialInput.alias,
                  iban: partialInput.iban,
                  amount: partialInput.amount,
                  variables: partialInput.variables)
    }
}

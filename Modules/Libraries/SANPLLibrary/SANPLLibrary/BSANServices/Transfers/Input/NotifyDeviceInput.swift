//
//  NotifyDeviceInput.swift
//  SANPLLibrary
//
//  Created by Carlos Monfort Gómez on 4/11/21.
//

import Foundation
import CoreDomain

public struct NotifyDeviceInput {
    public init(challenge: String,
                softwareTokenType: String?,
                notificationSchemaId: String,
                alias: String,
                iban: IBANRepresentable,
                amount: AmountRepresentable,
                variables: [String]? = nil) {
        self.challenge = challenge
        self.softwareTokenType = softwareTokenType
        self.notificationSchemaId = notificationSchemaId
        self.alias = alias
        self.iban = iban
        self.amount = amount
        self.variables = variables
    }
    
    let challenge: String
    let softwareTokenType: String?
    let notificationSchemaId: String
    let alias: String
    let iban: IBANRepresentable
    let amount: AmountRepresentable
    let variables: [String]?
}

//
//  NotifyDeviceInput.swift
//  SANPLLibrary
//
//  Created by Carlos Monfort Gómez on 4/11/21.
//

import Foundation
import CoreDomain

public struct NotifyDeviceInput {
    let challenge: String
    let softwareTokenType: String?
    let notificationSchemaId: String?
    let alias: String
    let iban: IBANRepresentable
    let amount: AmountRepresentable
}

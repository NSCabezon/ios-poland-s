//
//  NotifyDeviceParameters.swift
//  SANPLLibrary
//
//  Created by Carlos Monfort Gómez on 4/11/21.
//

import Foundation

struct NotifyDeviceParameters: Encodable {
    let userId: String
    let language: String
    let notificationSchemaId: String
    let variables: [String]
    let challenge: String
    let softwareTokenType: String?
}
//
//  CardDisableParameters.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/10/21.
//

import Foundation

public struct CardDisableParameters: Encodable {
    let virtualPan: String
    let reason: CardDisableReason
}

public enum CardDisableReason: String, Codable {
    case stolen = "STOLEN"
    case lost = "LOST"
    case tranNotAllowed = "TRAN_NOT_ALLOWED"
    case inATM = "IN_ATM"
    case destroyed = "DESTROYED"
}

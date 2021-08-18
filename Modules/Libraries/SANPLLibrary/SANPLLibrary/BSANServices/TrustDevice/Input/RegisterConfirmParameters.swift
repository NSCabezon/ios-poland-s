//
//  RegisterConfirmParameters.swift
//  SANPLLibrary
//
//  Created by Marcos Álvarez Mesa on 12/8/21.
//

import Foundation

public struct RegisterConfirmParameters: Encodable {
    let pinSoftwareTokenId: Int
    let timestamp: Int
    let secondFactorResponse: SecondFactorResponse

    public init(pinSoftwareTokenId: Int, timestamp: Int, secondFactorResponse: SecondFactorResponse) {
        self.pinSoftwareTokenId = pinSoftwareTokenId
        self.timestamp = timestamp
        self.secondFactorResponse = secondFactorResponse
    }
}

public struct SecondFactorResponse: Encodable {
    let device: String
    let value: String

    public init(device: String, value: String) {
        self.device = device
        self.value = value
    }
}

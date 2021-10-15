//
//  SetChequeBlikPinParameters.swift
//  SANPLLibrary
//
//  Created by 185167 on 07/10/2021.
//

public struct SetChequeBlikPinParameters: Encodable {
    public let chequePin: String
    
    public init(chequePin: String) {
        self.chequePin = chequePin
    }
}

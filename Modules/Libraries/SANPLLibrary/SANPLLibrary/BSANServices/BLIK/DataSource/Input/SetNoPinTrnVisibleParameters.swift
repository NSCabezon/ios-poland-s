//
//  SetNoPinTrnVisibleParameters.swift
//  SANPLLibrary
//
//  Created by 185167 on 21/02/2022.
//

public struct SetNoPinTrnVisibleParameters: Encodable {
    public let noPinTrnVisible: Bool
    
    public init(noPinTrnVisible: Bool) {
        self.noPinTrnVisible = noPinTrnVisible
    }
}

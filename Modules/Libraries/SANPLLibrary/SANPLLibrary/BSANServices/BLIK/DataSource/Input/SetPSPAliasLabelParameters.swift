//
//  SetPSPAliasLabelParameters.swift
//  SANPLLibrary
//
//  Created by 185167 on 15/10/2021.
//

public struct SetPSPAliasLabelParameters: Encodable {
    public let label: String
    
    public init(label: String) {
        self.label = label
    }
}

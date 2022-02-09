//
//  GetPayeesParameters.swift
//  SANPLLibrary
//
//  Created by Luis Escámez Sánchez on 30/9/21.
//

import Foundation

public struct GetPayeesParameters: Encodable {
    public let recCunt: Int?
    public let getOptions: Int?
    
    public init(recCunt: Int?, getOptions: Int? = nil) {
        self.recCunt = recCunt
        self.getOptions = getOptions
    }
}

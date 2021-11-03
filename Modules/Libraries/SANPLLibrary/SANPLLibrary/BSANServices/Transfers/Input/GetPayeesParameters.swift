//
//  GetPayeesParameters.swift
//  SANPLLibrary
//
//  Created by Luis Escámez Sánchez on 30/9/21.
//

import Foundation

public struct GetPayeesParameters: Encodable {
    public let recCunt: Int?
    
    public init(recCunt: Int?) {
        self.recCunt = recCunt
    }
}

//
//  OperationsProductsDTO.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 27/12/21.
//

import Foundation

public struct OperationsProductsDTO: Codable {
    public let type: String
    public let contracts: [OperationsProductsContractsDTO]?
}

public struct  OperationsProductsContractsDTO: Codable {
    public let id: String
    public let operations: [OperationsProductsStatesDTO]
}

public struct  OperationsProductsStatesDTO: Codable {
    public let id: String
    public let state: String
}

//
//  File.swift
//  SANPLLibrary
//
//  Created by 188216 on 14/12/2021.
//

import Foundation

public struct OperatorDTO: Codable {
    public let id: Int
    public let name: String
    public let topupValues: TopUpValuesDTO
    public let prefixes: [String]
}

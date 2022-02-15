//
//  TopUpValuesDTO.swift
//  SANPLLibrary
//
//  Created by 188216 on 14/12/2021.
//

import Foundation

public struct TopUpValuesDTO: Codable {
    public let type: String
    public let min: Int?
    public let max: Int?
    public let values: [TopUpValueDTO]
}

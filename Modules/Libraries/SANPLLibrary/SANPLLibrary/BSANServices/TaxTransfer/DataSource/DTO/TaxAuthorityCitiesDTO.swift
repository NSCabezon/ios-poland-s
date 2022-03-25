//
//  TaxAuthorityCitiesDTO.swift
//  SANPLLibrary
//
//  Created by 185167 on 17/03/2022.
//

public struct TaxAuthorityCitiesDTO: Decodable, Equatable {
    public let cityNames: [String]
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        cityNames = try container.decode([String].self)
    }
}

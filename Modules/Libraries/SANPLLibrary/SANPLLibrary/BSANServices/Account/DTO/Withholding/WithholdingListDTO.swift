//
//  WithholdingListDTO.swift
//  SANPLLibrary
//

import Foundation

public struct WithholdingListDTO: Codable {
    public let withholdingDTO: [WithholdingDTO]
    
    private enum CodingKeys: String, CodingKey {
        case withholdingDTO = "entries"
    }
}

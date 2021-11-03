//
//  TransactionsLinksDTO.swift
//  SANPTLibrary
//
//  Created by Felipe Lloret on 16/02/2021.
//

public struct TransactionsLinksDTO: Codable {
    public let next: String?
    public let previous: String?
    
    public init(next: String?, previous: String?) {
        self.next = next
        self.previous = previous
    }
    
    enum CodingKeys: String, CodingKey {
        case next = "pagingLast"
        case previous = "pagingFirst"
    }
}


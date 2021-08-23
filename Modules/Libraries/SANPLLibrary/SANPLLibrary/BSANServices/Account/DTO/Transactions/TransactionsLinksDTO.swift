//
//  TransactionsLinksDTO.swift
//  SANPTLibrary
//
//  Created by Felipe Lloret on 16/02/2021.
//

public struct TransactionsLinksDTO: Codable {
    public let first: String?
    public let next: String?
    public let previous: String?
    
    public init(first: String?, next: String?, previous: String?) {
        self.first = first
        self.next = next
        self.previous = previous
    }
    
    enum CodingKeys: String, CodingKey {
        case first = "_first"
        case next = "_next"
        case previous = "_prev"
    }
}


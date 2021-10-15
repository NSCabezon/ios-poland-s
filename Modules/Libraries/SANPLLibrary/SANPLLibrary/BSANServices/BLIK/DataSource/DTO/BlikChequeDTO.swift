//
//  BlikChequeDTO.swift
//  SANPLLibrary
//
//  Created by Piotr Mielcarzewicz on 22/06/2021.
//

public struct BlikChequeDTO: Codable {
    public let authCodeId: Int
    public let ticketData: TicketData
    public let transaction: Transaction
    
    public struct TicketData: Codable {
        public let ticket: String
        public let amount: Double
        public let name: String
        public let currency: String
        public let createTime: String
        public let cancelTime: String?
        public let executionTime: String?
        public let expiryTime: String
        public let status: String
    }
    
    public struct Transaction: Codable {
        public let amount: Double?
        public let status: String?
    }
}

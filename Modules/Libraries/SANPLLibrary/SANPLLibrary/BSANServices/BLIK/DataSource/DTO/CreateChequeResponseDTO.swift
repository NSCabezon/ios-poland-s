//
//  CreateChequeResponseDTO.swift
//  SANPLLibrary
//
//  Created by Piotr Mielcarzewicz on 15/07/2021.
//

public struct CreateChequeResponseDTO: Codable {
    public let authCodeId: String
    public let ticket: String
    public let ticketTime: TimeInterval
}

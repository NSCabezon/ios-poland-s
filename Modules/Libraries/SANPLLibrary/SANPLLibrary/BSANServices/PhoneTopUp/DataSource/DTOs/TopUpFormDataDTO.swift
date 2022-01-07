//
//  TopUpFormDataDTO.swift
//  SANPLLibrary
//
//  Created by 188216 on 17/12/2021.
//

import Foundation

public struct TopUpFormDataDTO: Codable {
    public let accounts: [DebitAccountDTO]
    public let operators: [OperatorDTO]
    public let gsmOperators: [GSMOperatorDTO]
    public let internetContacts: [PayeeDTO]
}

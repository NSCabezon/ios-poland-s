//
//  SplitPaymentFormDataDTO.swift
//  SANPLLibrary
//
//  Created by 189501 on 15/03/2022.
//

import Foundation

public struct SplitPaymentFormDataDTO: Codable {
    public let accounts: [DebitAccountDTO]
}

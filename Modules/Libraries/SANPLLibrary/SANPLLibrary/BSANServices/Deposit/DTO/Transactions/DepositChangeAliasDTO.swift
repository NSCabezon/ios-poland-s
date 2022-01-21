//
//  DepositChangeAliasDTO.swift
//  SANPLLibrary
//
//  Created by Alvaro Royo on 14/1/22.
//

import Foundation

public struct DepositChangeAliasDTO: Codable {
	public let systemId: Int?
	public let productId: String?
	public let userDefined: String?
}

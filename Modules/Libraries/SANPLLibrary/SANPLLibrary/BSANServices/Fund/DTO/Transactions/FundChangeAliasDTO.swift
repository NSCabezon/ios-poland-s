//
//  FundChangeAliasDTO.swift
//  SANPLLibrary
//
//  Created by Alvaro Royo on 15/1/22.
//

import Foundation

public struct FundChangeAliasDTO: Codable {
	public let systemId: Int?
	public let productId: String?
	public let userDefined: String?
}

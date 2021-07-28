//
//  SwiftBranchesDTO.swift
//  SANPLLibrary
//

import Foundation

public struct SwiftBranchesDTO: Codable {
    public let swiftBranchList: [SwiftBranchDTO]?
    public let page: SwiftBranchesPageDTO?
}

public struct SwiftBranchDTO: Codable {
    public let branchId: Int?
    public let bic: String?
    public let branchCode: String?
    public let bankName: String?
    public let countryCode: String?
    public let city: String?
    public let address: String?
    public let shortName: String?
}

public struct SwiftBranchesPageDTO: Codable {
    public let operationCount: Int?
    public let hasNextPage: Bool?
    public let navigationKey: String?
}

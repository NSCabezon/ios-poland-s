//
//  PLAccountDetailDTO.swift
//  SANPLLibrary
//
//  Created by Carlos Monfort Gómez on 17/5/22.
//

import Foundation

public protocol PLAccountDetailRepresentable {
    var number: String? { get }
    var ownerRepresentable: PLAccountDetailOwnerRepresentable? { get }
    var branchRepresentable: PLAccountDetailBranchRepresentable? { get }
    var currency: Int? { get }
    var currencyCode: String? { get }
}

public protocol PLAccountDetailOwnerRepresentable {
    var customerName: String? { get }
    var street: String? { get }
    var city: String? { get }
}

public protocol PLAccountDetailBranchRepresentable {
    var id: Int? { get }
}

public struct PLAccountDetailDTO: Codable {
    public let number: String?
    public let owner: PLAccountDetailOwnerDTO?
    public let branch: PLAccountDetailBranchDTO?
    public let currency: Int?
    public let currencyCode: String?
}

extension PLAccountDetailDTO: PLAccountDetailRepresentable {
    public var ownerRepresentable: PLAccountDetailOwnerRepresentable? {
        return self.owner
    }
    
    public var branchRepresentable: PLAccountDetailBranchRepresentable? {
        return self.branch
    }
}

public struct PLAccountDetailOwnerDTO: Codable {
    public let customerName: String?
    public let street: String?
    public let city: String?
}

extension PLAccountDetailOwnerDTO: PLAccountDetailOwnerRepresentable {}

public struct PLAccountDetailBranchDTO: Codable {
    public let id: Int?
}

extension PLAccountDetailBranchDTO: PLAccountDetailBranchRepresentable {}

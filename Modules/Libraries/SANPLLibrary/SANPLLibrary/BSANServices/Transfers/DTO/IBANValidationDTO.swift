//
//  IBANValidationDTO.swift
//  SANPLLibrary
//

import CoreDomain

struct IBANValidationDTO: Codable {
    let number: String?
    let owner: OwnerDTO?
    let branch: BranchDTO?
    let currency: Int?
    let currencyCode: String?
}

struct BranchDTO: Codable {
    let id: Int?
    let name: String?
    let external: Bool?
}

struct OwnerDTO: Codable {
    let customerName: String?
    let street: String?
    let city: String?
}

extension IBANValidationDTO: CheckInternalAccountRepresentable {
    var isExternal: Bool {
        return self.branch?.external ?? false
    }
}

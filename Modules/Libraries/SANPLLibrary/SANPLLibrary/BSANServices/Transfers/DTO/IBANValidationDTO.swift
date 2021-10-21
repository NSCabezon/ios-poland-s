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
}

struct OwnerDTO: Codable {
    let customerName: String?
    let street: String?
    let city: String?
}

extension IBANValidationDTO: PLTransferNationalRepresentable {
    var accountNumber: String? {
        self.number
    }
    
    var issueDate: Date? {
        nil
    }
    
    var destinationAccountDescription: String? {
        nil
    }
    
    var originAccountDescription: String? {
        nil
    }
    
    var payerName: String? {
        nil
    }
    
    var scaRepresentable: SCARepresentable? {
        nil
    }
}

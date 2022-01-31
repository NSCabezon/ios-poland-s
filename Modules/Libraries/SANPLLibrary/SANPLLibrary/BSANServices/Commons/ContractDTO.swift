//
//  ContractDTO.swift
//  SANPTLibrary
//
//  Created by Juan Carlos López Robles on 12/27/21.
//

import Foundation
import CoreDomain

struct ContractDTO {
    var bankCode: String?
    var branchCode: String?
    var product: String?
    var contractNumber: String?
    var contratoPK: String?
}

extension ContractDTO: ContractRepresentable {
    public var formattedValue: String {
        if let bankCode = bankCode, let branchCode = branchCode, let contractNumber = contractNumber, let product = product {
            if "0030" == bankCode {
                return bankCode + branchCode + contractNumber + product
            } else {
                return bankCode + branchCode + product + contractNumber
            }
        } else {
            return ""
        }
    }
    
    public var description: String {
        return ""
    }
}

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

extension ContractDTO: ContractRepresentable {}

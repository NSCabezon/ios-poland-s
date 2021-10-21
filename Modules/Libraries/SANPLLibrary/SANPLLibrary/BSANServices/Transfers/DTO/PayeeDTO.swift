//
//  PayeeDTO.swift
//  SANPLLibrary
//
//  Created by Luis Escámez Sánchez on 30/9/21.
//

import Foundation
import CoreDomain
import SANLegacyLibrary

public struct PayeeDTO: Codable {
    let payeeID: PayeeIdDTO?
    public let alias: String?
    public let account: Account?

    enum CodingKeys: String, CodingKey {
        case payeeID = "payeeId"
        case alias, account
    }
}

extension PayeeDTO: PayeeRepresentable {
    public var payeeAlias: String? {
        self.alias
    }
    
    public var ibanRepresentable: IBANRepresentable? {
        guard let displayNumber = self.account?.accountNo else {
            return nil
        }
        return IBANDTO(ibanString: displayNumber)
    }
}

public struct Account: Codable {
    var accountType: AccountTypeDTO?
    var currencyCode: String?
    public var accountNo: String?
    var payeeName: String?
    var branchInfo: BranchInfoDTO?
    var address: String?
    var taxFormType: String?
    var validFrom: String?
    var transferType: String?
    var status: String?
    var swiftData: SwiftDataDTO?
}

public struct AccountTypeDTO: Codable {
    let code: Int?
    let name: String?
    let details: PayeeAccountDetailsDTO?
}

public struct PayeeAccountDetailsDTO: Codable {
    let accountTypeOptions: Int?
    let transactionMask: TransactionMaskDTO?
}

public struct BranchInfoDTO: Codable {
    let branchCode: String?
    let branchName: String?
}

public struct SwiftDataDTO: Codable {
    let isActive: Bool?
    let id: String?
    let bic: String?
    let branchInfo: BranchInfoDTO?
    let bankName: String?
    let town: String?
    let country: String?
    let address: String?
    let type: String?
    let mode: String?
    let priority: String?
    let cost: String?
    let customerEmail: String?
    let payment: PaymentDTO?
    let instructions: String?
}

public struct PaymentDTO: Codable {
    let accountNo: String?
    let currencyCode: String?
}

public struct PayeeIdDTO: Codable {
    let contractType: String?
    let id: String?
}

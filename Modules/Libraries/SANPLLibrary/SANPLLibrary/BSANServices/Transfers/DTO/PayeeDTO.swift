//
//  PayeeDTO.swift
//  SANPLLibrary
//
//  Created by Luis Escámez Sánchez on 30/9/21.
//

import SANLegacyLibrary
import CoreDomain
import Foundation

public struct PayeeDTO: Codable {
    let payeeID: PayeeIdDTO?
    public let alias: String?
    public let account: AccountPayeeDTO?
    public let phone: PayeePhoneDTO?

    enum CodingKeys: String, CodingKey {
        case payeeID = "payeeId"
        case alias, account, phone
    }
}

extension PayeeDTO: PayeeRepresentable {
    public var destinationAccountDescription: String {
        guard let countryCode = ibanRepresentable?.countryCode,
              let checkDigits = ibanRepresentable?.checkDigits,
              let codBban = ibanRepresentable?.codBban
        else {
            return ""
        }
        return "\(countryCode)\(checkDigits)\(codBban)"
    }
    
    public var shortAccountNumber: String? {
        guard let last4Numbers = account?.accountNo?.suffix(4) else {
            return nil
        }
        return "*" + last4Numbers
    }
    
    public var payeeId: String? {
        return payeeID?.id
    }
    
    public var payeeAlias: String? {
        return self.alias
    }
    
    public var payeeName: String? {
        return nil
    }
    
    public var payeeCode: String? {
        return nil
    }
    
    public var currencyName: String? {
        return self.account?.currencyCode
    }
    
    public var currencySymbol: String? {
        guard let currencyCode = self.account?.currencyCode else { return nil }
        return SANLegacyLibrary.CurrencyDTO.create(currencyCode).getSymbol()
    }
    
    public var payeeAddress: String? {
        return self.account?.address
    }
    
    public var ibanPapel: String {
        guard let ibanPapel = ibanRepresentable?.ibanPapel else { return "****" }
        return ibanPapel
    }
    
    public var shortIBAN: String {
        guard let ibanShort = ibanRepresentable?.ibanShort(showCountryCode: false, asterisksCount: 1, lastDigitsCount: 4) else { return "****" }
        return ibanShort
    }
    
    public var entityCode: String? {
        guard let entityCode = self.ibanRepresentable?.getEntityCode() else { return nil }
        return entityCode
    }
    
    public var baoName: String? {
        return nil
    }
    
    public var formattedAccount: String? {
        guard let ibanRepresentable = ibanRepresentable else { return nil }
        if !["ES", "PT", "PL"].contains(ibanRepresentable.countryCode.uppercased()) {
            return ibanRepresentable.countryCode + ibanRepresentable.checkDigits + " " + ibanRepresentable.codBban
        }
        return ibanRepresentable.ibanPapel
    }
    
    public var isNoSepa: Bool {
        return false
    }
    
    public var ibanRepresentable: IBANRepresentable? {
        guard let displayNumber = self.account?.accountNo else {
            return nil
        }
        return IBANDTO(ibanString: displayNumber)
    }
    
    public var accountType: String? {
        return payeeID?.contractType
    }
    
    public var destinationAccount: String? {
        return nil
    }
    
    public var recipientType: String? {
        return nil
    }
    
    public var countryCode: String? {
        get {
            return self.ibanRepresentable?.countryCode
        }
        set {}
    }
}

public struct AccountPayeeDTO: Codable {
    var accountType: AccountTypeDTO?
    var currencyCode: String?
    public var accountNo: String?
    public var payeeName: String?
    var branchInfo: BranchInfoDTO?
    public var address: String?
    var taxFormType: String?
    var validFrom: String?
    public var transferType: String?
    public var transactionTitle: String?
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
    let id: Int?
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

public struct PayeePhoneDTO: Codable {
    public let phoneNo: String
    public let gsmOperatorId: Int
    public let highAuthFlag: Bool
}

//
//  AccountForDebitDTO.swift
//  SANPLLibrary
//

import Foundation
import CoreDomain
import SANLegacyLibrary

public protocol PolandAccountRepresentable: AccountRepresentable {
    var type: AccountForDebitTypeDTO? { get }
    var sequencerNo: Int? { get }
    var accountType: Int? { get }
}

struct AccountForDebitDTO: Codable {
    let number: String?
    let id: String?
    let currencyCode: String?
    let name: AccountForDebitNameDTO?
    let type: AccountForDebitTypeDTO?
    let balance: BalanceDTO?
    let availableFunds: BalanceDTO?
    let systemId: Int?
    let defaultForPayments: Bool?
    let role: String?
    let accountDetails: AccountDetailsAccountForDebitDTO?
    let creditCardAccountDetails: CreditCardAccountDetailsDTO?
    let transactionMask: TransactionMaskDTO?
    let lastUpdate: String?
    var isVisible: Bool = true
}

struct AccountForDebitNameDTO: Codable {
    let source: String?
    let description: String?
    let userDefined: String?
}

struct AccountDetailsAccountForDebitDTO: Codable {
    let interestRateIndicator: String?
    let sequenceNumber: Int?
    let accountType: Int?
}

struct CreditCardAccountDetailsDTO: Codable {
    let paymentDate: String?
    let totalPaymentAmount: BalanceDTO?
    let minimalPaymentAmount: BalanceDTO?
}

struct TransactionMaskDTO: Codable {
    let debit: String?
    let credit: String?
}

extension AccountForDebitDTO: AccountRepresentable {
    var currencyName: String? {
        self.currencyCode
    }
    
    var alias: String? {
        self.name?.userDefined?.isEmpty ?? true ? self.name?.description : self.name?.userDefined
    }
    
    var currentBalanceRepresentable: AmountRepresentable? {
        self.adaptBalanceToAmount(self.availableFunds)
    }
    
    var ibanRepresentable: IBANRepresentable? {
        guard let displayNumber = self.number else {
            return nil
        }
        return IBANDTO(ibanString: displayNumber)
    }
    
    var contractNumber: String? {
        self.id
    }
    
    var contractRepresentable: ContractRepresentable? {
        ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: self.id)
    }
    
    var isMainAccount: Bool? {
        self.defaultForPayments
    }
    
    var currencyRepresentable: CurrencyRepresentable? {
        guard let currencyName = self.balance?.currencyCode else { return nil }
        let currencyType = CurrencyType.parse(currencyName)
        return CurrencyDTO(currencyName: currencyName, currencyType: currencyType)
    }
    
    var getIBANShort: String {
        let ibanShort = ibanRepresentable?.ibanShort(
            showCountryCode: false,
            asterisksCount: 1,
            lastDigitsCount: 4
        )
        return ibanShort ?? "****"
    }
    
    var getIBANPapel: String {
        guard let ibanPapel = ibanRepresentable?.ibanPapel else { return "****" }
        return ibanPapel
    }
    
    var getIBANString: String {
        guard let ibanString = ibanRepresentable?.ibanString else { return "****" }
        return ibanString
    }
    
    var appIdentifier: String {
        return id ?? ""
    }
}

extension AccountForDebitDTO: PolandAccountRepresentable {
    var sequencerNo: Int? {
        self.accountDetails?.sequenceNumber
    }
    
    var accountType: Int? {
        self.accountDetails?.accountType
    }
}

private extension AccountForDebitDTO {
    func adaptBalanceToAmount(_ balance: BalanceDTO?) -> SANLegacyLibrary.AmountDTO? {
        return self.makeAmountDTO(value: balance?.value, currencyCode: balance?.currencyCode)
    }
    
    func makeAmountDTO(value: Double?, currencyCode: String?) -> SANLegacyLibrary.AmountDTO? {
        guard let amount = value,
              let currencyCode = currencyCode else {
            return nil
        }
        let currencyType: CurrencyType = CurrencyType.parse(currencyCode)
        let balanceAmount = Decimal(amount)
        let currencyDTO = SANLegacyLibrary.CurrencyDTO(currencyName: currencyCode, currencyType: currencyType)
        return SANLegacyLibrary.AmountDTO(value: balanceAmount, currency: currencyDTO)
    }
}

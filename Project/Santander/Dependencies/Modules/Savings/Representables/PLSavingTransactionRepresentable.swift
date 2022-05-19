//
//  PLSavingTransactionRepresentable.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation
import SANPLLibrary
import CoreDomain
import SANLegacyLibrary

public struct PLSavingTransactionRepresentable: SavingTransactionRepresentable {
    public var accountId: String
    public var amount: SavingAmountRepresentable
    public var creditDebitIndicator: String
    public var status: String
    public var transactionMutability: String
    public var bookingDateTime: Date
    
    public var transactionId: String?
    public var transactionReference: String?
    public var valueDateTime: Date?
    public var transactionInformation: String?
    public var bankTransactionCode: BankSavingTransactionCodeRepresentable?
    public var proprietaryBankTransactionCode: ProprietaryBankSavingTransactionCodeRepresentable?
    public var balance: SavingTransactionBalanceRepresentable?
    public var supplementaryData: SavingTransactionSupplementaryDataRepresentable?
    
    init(dto: SavingTransactionDTO) {
        self.accountId = dto.accountNumber ?? "" // TODO: Not sure about this
        self.amount = PLSavingAmountRepresentable(amount: String(format: "%.2f", dto.amount ?? 0.0),
                                                  currency: dto.currency ?? "-")
        self.creditDebitIndicator = dto.debitFlag ?? ""
        self.status = ""
        self.transactionMutability = ""
        
        self.bookingDateTime = DateFormats.toDate(string: dto.operTime ?? "", output: DateFormats.TimeFormat.YYYYMMDD_HHmmss) ?? Date()
        
        let balance = PLSavingAmountRepresentable(amount: String(format: "%.2f", dto.balance ?? 0.0),
                                                 currency: dto.currency ?? "PLN")
        self.balance = PLSavingTransactionBalanceRepresentable(type: dto.transType ?? "-",
                                                               amount: balance,
                                                               creditDebitIndicator: dto.debitFlag ?? "")
        self.supplementaryData = PLSavingTransactionSupplementaryDataRepresentable(shortDescription: dto.transTitle ?? "-")
    }
    
    init(dto: SavingTermTransactionDTO) {
        self.accountId = dto.extraData?.sideDebit?.accountNo ?? dto.extraData?.sideCredit?.accountNo ?? ""
        self.amount = PLSavingAmountRepresentable(amount: String(format: "%.2f", dto.amount ?? 0.0),
                                                  currency: dto.extraData?.operationCurrency ?? "PLN")
        let balance = PLSavingAmountRepresentable(amount: String(format: "%.2f", dto.balance ?? 0.0),
                                                 currency: dto.extraData?.operationCurrency ?? "PLN")
        self.balance = PLSavingTransactionBalanceRepresentable(type: dto.extraData?.operationType ?? "-",
                                                               amount: balance,
                                                               creditDebitIndicator: "")
        
        self.supplementaryData = PLSavingTransactionSupplementaryDataRepresentable(shortDescription: dto.extraData?.extendedTitle ?? "-")
        self.status = ""
        self.transactionMutability = ""
        self.creditDebitIndicator = ""
        self.bookingDateTime = DateFormats.toDate(string: dto.dateValue ?? "", output: DateFormats.TimeFormat.YYYYMMDD_HHmmss) ?? Date()
    }
}

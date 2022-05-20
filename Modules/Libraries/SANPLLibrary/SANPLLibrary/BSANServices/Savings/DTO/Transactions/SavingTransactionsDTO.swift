//
//  SavingTransactionsDTO.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 7/4/22.
//

import Foundation

public struct SavingTransactionsDTO: Codable {
    public let entries: [SavingTransactionDTO]?
    public let pagingFirst: String?
    public let pagingLast: String?
    public let altered: Bool?
}

public struct SavingTransactionDTO: Codable {
    public let transTitle: String?
    public let transType: String?
    public let balance: Double?
    public let currency: String?
    public let sourceDate: String?
    public let amount: Double?
    public let postedDate: String?
    public let accountNumber: String?
    public let postingRef: String?
    public let sourceRef: String?
    public let operTime: String?
    public let transSubtype: String?
    public let transTypeDesc: String?
    public let debitFlag: String?
    public let sepaFlag: Bool?
    public let cardMasked: String?
    public let cardNo: String?
    public let cardTransType: String?
    public let acceptor: String?
    public let acceptorType: String?
    public let othCustAccNo: String?
    public let othCustName: String?
    public let amountOth: Double?
    public let amountPln: Double?
    public let currencyOth: String?
    public let currencyRate: Double?
    public let currencyRateOth: Double?
    public let bankSubcat: Int?
    public let finalCat: Int?
    public let catAutoTime: String?
    public let catUserTime: String?
    public let lp: Double?
    public let callTime: String?
    public let currencyCodeDt: String?
    public let currencyCodeCt: String?
    public let amountBill: Double?
    public let currencyBillS: String?
    public let employee: String?
    public let state: String?
    public let custName: String?
    public let receiptId: String?
}

//
//  CardTransactionDTO.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 13/8/21.
//

import Foundation

public struct CardTransactionDTO: Codable {
    public let accountNumber: String?
    public let postingRef: String?
    public let postedDate: String?
    public let sourceRef: String?
    public let sourceDate: String?
    public let operTime: String?
    public let transType: String?
    public let transSubtype: String?
    public let transTypeDesc: String?
    public let debitFlag: String?
    public let sepaFlag: Bool?
    public let cardMasked: String?
    public let cardNo: String?
    public let cardTransType: String?
    public let acceptor: String?
    public let acceptorType: String?
    public let transTitle: String?
    public let othCustAccNo: String?
    public let othCustName: String?
    public let amount: Decimal?
    public let amountOth: Decimal?
    public let amountPln: Decimal?
    public let currency: String?
    public let currencyOth: String?
    public let currencyRate: Decimal?
    public let currencyRateOth: Double?
    public let balance: Decimal?
    public let bankSubcat: Decimal?
    public let custSubcat: Decimal?
    public let finalSubcat: Decimal?
    public let finalCat: Decimal?
    public let catAutoTime: String?
    public let catUserTime: String?
    public let lp: Decimal?
    public let callTime: String?
    public let currencyCodeDt: String?
    public let currencyCodeCt: String?
    public let amountBill: Decimal?
    public let currencyyBillS: String?
    public let employee: String?
    public let state: String?
    public let custName: String?
    
}

//
//  WithholdingListDTO.swift
//  SANPLLibrary
//

import Foundation

public struct WithholdingDTO: Codable {
    public let accountNumber: String?
    public let sourceDate: String?
    public let operTime: String?
    public let transType: String?
    public let transSubtype: String?
    public let transTypeDesc: String?
    
    public let debitFlag: String?
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
    public let currencyRateOth: Decimal?
    public let lp: Decimal?
    public let currencyCodeDt: String?
    
    public let currencyCodeCt: String?
    public let amountBill: Decimal?
    public let currencyBillS: String?
}

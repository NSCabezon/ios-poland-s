//
//  ConfirmationTransferDTO.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 5/11/21.
//

import Foundation

public struct ConfirmationTransferDTO: Codable {
    public let customerAddressData: CustomerAddressDataDTO?
    public let debitAmountData: ItAmountDataDTO?
    public let creditAmountData: ItAmountDataDTO?
    public let debitAccountData: ItAccountDataDTO?
    public let creditAccountData: ItAccountDataDTO?
    public let transactionAmountData: TransactionAmountDataDTO?
    public let title: String?
    public let type: String?
    public let valueDate: String?
    public let sendApplicationId: Int?
    public let timestamp: Int?
    public let options: Int?
    public let ownerCifNumber: Int?
    public let transactionSide: String?
    public let noFixedRate: Int?
    public let customerRef: String?
    public let transferType: String?
    public let key: KeyDTO?
    public let signHistoryData: [SignHistoryDatumDTO]?
    public let state: String?
    public let sendError: Int?
    public let postingId: Int?
    public let acceptanceTime: String?
}

// MARK: - ItAccountData
public struct ItAccountDataDTO: Codable {
    public let accountType: Int?
    public let accountSequenceNumber: Int?
    public let branchId: String?
    public let accountNo: String?
    public let accountName: String?
}

// MARK: - ItAmountData
public struct ItAmountDataDTO: Codable {
    public let currency: String?
    public let amount: Double?
    public let currencyRate: String?
    public let currencyUnit: Int?
}

// MARK: - CustomerAddressData
public struct CustomerAddressDataDTO: Codable {
    let customerName: String?
    let city: String?
    let street: String?
    let zipCode: String?
    let baseAddress: String?
}

// MARK: - Key
public struct KeyDTO: Codable {
    let id: Int?
    let date: String?
}

// MARK: - SignHistoryDatum
public struct SignHistoryDatumDTO: Codable {
    let signLoginId: Int?
    let signResult: Int?
    let signTime: String?
    let signTrnState: String?
    let signCifNumber: Int?
    let signApplicationId: Int?
}

// MARK: - TransactionAmountData
public struct TransactionAmountDataDTO: Codable {
    let baseAmount: Double?
}

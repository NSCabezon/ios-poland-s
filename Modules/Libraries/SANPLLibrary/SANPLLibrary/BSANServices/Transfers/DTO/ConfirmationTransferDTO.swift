//
//  ConfirmationTransferDTO.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 5/11/21.
//

import Foundation

public struct ConfirmationTransferDTO: Codable {
    let customerAddressData: CustomerAddressDataDTO?
    let debitAmountData: ItAmountDataDTO?
    let creditAmountData: ItAmountDataDTO?
    let debitAccountData: ItAccountDataDTO?
    let creditAccountData: ItAccountDataDTO?
    let transactionAmountData: TransactionAmountDataDTO?
    let title: String?
    let type: String?
    let valueDate: String?
    let sendApplicationId: Int?
    let timestamp: Int?
    let options: Int?
    let ownerCifNumber: Int?
    let transactionSide: String?
    let noFixedRate: Int?
    let customerRef: String?
    let transferType: String?
    let key: KeyDTO?
    let signHistoryData: [SignHistoryDatumDTO]?
    let state: String?
    let sendError: Int?
    let postingId: Int?
    let acceptanceTime: String?
}

// MARK: - ItAccountData
public struct ItAccountDataDTO: Codable {
    let accountType: Int?
    let accountSequenceNumber: Int?
    let branchId: String?
    let accountNo: String?
    let accountName: String?
}

// MARK: - ItAmountData
public struct ItAmountDataDTO: Codable {
    let currency: String?
    let amount: Double?
    let currencyRate: String?
    let currencyUnit: Int?
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

//
//  CharityTransferModel.swift
//  CharityTransfer
//
//  Created by 187830 on 08/11/2021.
//

import PLUI
import PLCommons

public struct CharityTransferModel {
    public let amount: Decimal?
    public let title: String?
    public let account: AccountForDebit
    public let recipientName: String?
    public let transactionType: TransactionType
    public let date: Date?
}

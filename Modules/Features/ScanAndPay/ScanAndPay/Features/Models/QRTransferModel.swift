//
//  QrTransferModel.swift
//  ScanAndPay
//
//  Created by 188216 on 21/03/2022.
//

import Foundation

struct QRTransferModel {
    let taxIdentifier: String?
    let countryCode: String
    let accountNumber: String
    let ammount: Int? // amount in cents
    let recipientName: String
    let transferTitle: String?
    let reserveField1: String?
    let reserveField2: String?
    let reserveField3: String?
}

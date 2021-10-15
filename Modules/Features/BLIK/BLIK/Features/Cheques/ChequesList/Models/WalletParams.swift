//
//  WalletParams.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 22/06/2021.
//

struct WalletParams: Codable {
    let activeChequesLimit: Int
    let maxChequeAmount: Decimal
}

//
//  WalletParamsDTO.swift
//  Pods
//
//  Created by Piotr Mielcarzewicz on 22/06/2021.
//

public struct WalletParamsDTO: Codable {
    public let singleLimitMax: Int
    public let singleLimitMin: Int
    public let shopSingleLimitMax: Int
    public let cycleLimitMax: Int
    public let cycleLimitMin: Int
    public let shopCycleLimitMax: Int
    public let noPinLimitMax: Int
    public let noConfLimitMax: Int
    public let maxChequeAmount: Int
    public let maxActiveCheques: Int
}

//
//  BlikCheque.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/06/2021.
//

import PLCommons

public struct BlikCheque {
    let id: Int
    let ticketCode: String
    let title: String
    let value: Money
    let creationDate: Date
    let expirationDate: Date
    let status: Status
    
    public enum Status: Equatable {
        case active
        case expired
        case canceled
        case rejected
        case executed(Money?)
    }
}

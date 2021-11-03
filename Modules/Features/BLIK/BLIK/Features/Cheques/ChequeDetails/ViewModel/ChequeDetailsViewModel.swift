//
//  ChequeDetailsViewModel.swift
//  BLIK
//
//  Created by 186491 on 22/06/2021.
//

struct ChequeDetailsViewModel {
    public struct Item {
        let name: String
        let value: String
    }
    public let chequeName: String
    public let items: [Item]
    public let shouldShowFooter: Bool
}

//
//  TaxAuthority.swift
//  TaxTransfer
//
//  Created by 185167 on 03/02/2022.
//

public struct TaxAuthority: Equatable {
    let id: String
    let name: String
    let accountNumber: String
    let address: String?
    let taxAccountType: TaxAccountType
}

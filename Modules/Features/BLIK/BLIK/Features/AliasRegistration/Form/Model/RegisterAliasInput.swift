//
//  RegisterAliasInput.swift
//  BLIK
//
//  Created by 185167 on 19/10/2021.
//

struct RegisterAliasInput {
    let aliasProposal: Transaction.AliasProposal
    let merchantId: String?
    let acquirerId: Int?
}

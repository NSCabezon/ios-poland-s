//
//  DeleteAliasRequest.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 07/09/2021.
//

struct DeleteAliasRequest {
    let alias: BlikAlias
    let deletionReason: DeleteAliasReason
}

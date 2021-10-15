//
//  BlikAliasNewLabelMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 13/09/2021.
//

protocol BlikAliasNewLabelMapping {
    func map(alias: BlikAlias, withNewLabel newLabel: String) -> BlikAlias
}

final class BlikAliasNewLabelMapper: BlikAliasNewLabelMapping {
    func map(alias: BlikAlias, withNewLabel newLabel: String) -> BlikAlias {
        return BlikAlias(
            walletId: alias.walletId,
            label: newLabel,
            type: alias.type,
            alias: alias.alias,
            acquirerId: alias.acquirerId,
            merchantId: alias.merchantId,
            expirationDate: alias.expirationDate,
            proposalDate: alias.proposalDate,
            status: alias.status,
            aliasUsage: alias.aliasUsage
        )
    }
}

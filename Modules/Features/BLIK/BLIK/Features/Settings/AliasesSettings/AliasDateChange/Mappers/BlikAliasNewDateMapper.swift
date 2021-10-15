protocol BlikAliasNewDateMapping {
    func map(alias: BlikAlias, validityPeriod: AliasDateValidityPeriod) -> BlikAlias
}

final class BlikAliasNewDateMapper: BlikAliasNewDateMapping {
    func map(alias: BlikAlias, validityPeriod: AliasDateValidityPeriod) -> BlikAlias {
        let newExpirationDate = Date().addMonth(months: validityPeriod.rawValue)
        return BlikAlias(
            walletId: alias.walletId,
            label: alias.label,
            type: alias.type,
            alias: alias.alias,
            acquirerId: alias.acquirerId,
            merchantId: alias.merchantId,
            expirationDate: newExpirationDate,
            proposalDate: alias.proposalDate,
            status: alias.status,
            aliasUsage: alias.aliasUsage
        )
    }
}

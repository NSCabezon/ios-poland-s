//
//  RegisterAliasInputMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 13/09/2021.
//

import SANPLLibrary

protocol RegisterAliasParametersMapping {
    func map(_ alias: BlikAlias) -> RegisterBlikAliasParameters
}

final class RegisterAliasParametersMapper: RegisterAliasParametersMapping {
    private let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    func map(_ alias: BlikAlias) -> RegisterBlikAliasParameters {
        let aliasType: Transaction.AliasProposalType = alias.type == .internetBrowser ? .cookie : .uid
        
        return RegisterBlikAliasParameters(
            aliasLabel: alias.label,
            aliasValueType: aliasType.rawValue,
            alias: alias.alias,
            acquirerId: alias.acquirerId,
            merchantId: alias.merchantId,
            expirationDate: dateFormatter.string(from: alias.expirationDate),
            aliasURL: nil,
            platform: "IOS",
            registerInPSP: true
        )
    }
}

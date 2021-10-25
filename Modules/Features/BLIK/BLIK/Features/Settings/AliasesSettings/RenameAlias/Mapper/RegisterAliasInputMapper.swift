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
        return RegisterBlikAliasParameters(
            aliasLabel: alias.label,
            aliasValueType: alias.type.rawValue,
            alias: alias.alias,
            acquirerId: alias.acquirerId,
            merchantId: alias.merchantId,
            // TODO:- Expiration date taken form API model is optional while register endpoint requires non-nil date, pending refinement with a team
            expirationDate: dateFormatter.string(from: alias.expirationDate ?? Date()),
            // TODO:- Find out what do arguments below mean, pending refinement with a team
            aliasURL: nil,
            platform: nil,
            registerInPSP: false
        )
    }
}

//
//  BlikCustomerAccountMapper.swift
//  BLIK
//
//  Created by 185167 on 26/10/2021.
//

import SANPLLibrary
import PLCommons

protocol BlikCustomerAccountMapping {
    func map(dto: BlikCustomerAccountDTO) -> BlikCustomerAccount
}

final class BlikCustomerAccountMapper: BlikCustomerAccountMapping {
    func map(dto: BlikCustomerAccountDTO) -> BlikCustomerAccount {
        return BlikCustomerAccount(
            id: dto.id,
            name: dto.name.userDefined.isEmpty ? dto.name.description : dto.name.userDefined,
            number: dto.number,
            availableFunds: Money(
                amount: dto.availableFunds.value,
                currency: dto.availableFunds.currencyCode
            ),
            defaultForPayments: dto.defaultForPayments,
            defaultForP2P: dto.defaultForP2P
        )
    }
}


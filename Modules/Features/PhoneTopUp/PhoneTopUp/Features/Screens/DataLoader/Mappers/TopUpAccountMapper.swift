//
//  TopUpAccountMapper.swift
//  PhoneTopUp
//
//  Created by 188216 on 03/03/2022.
//

import SANPLLibrary
import Foundation

protocol TopUpAccountMapping {
    func map(dto: PopularAccountDTO) -> TopUpAccount
}

final class TopUpAccountMapper: TopUpAccountMapping {
    public init() {}
    
    public func map(dto: PopularAccountDTO) -> TopUpAccount {
        return TopUpAccount(number: dto.number, name: dto.name)
    }
}

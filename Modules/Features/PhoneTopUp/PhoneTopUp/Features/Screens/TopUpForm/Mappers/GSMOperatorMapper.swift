//
//  GSMOperatorMapper.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/12/2021.
//

import SANPLLibrary
import Foundation

public protocol GSMOperatorMapping {
    func map(dto: GSMOperatorDTO) -> GSMOperator
}

public final class GSMOperatorMapper: GSMOperatorMapping {
    public init() {}
    
    public func map(dto: GSMOperatorDTO) -> GSMOperator {
        return GSMOperator(id: dto.id, blueMediaId: dto.blueMediaId, name: dto.name)
    }
}

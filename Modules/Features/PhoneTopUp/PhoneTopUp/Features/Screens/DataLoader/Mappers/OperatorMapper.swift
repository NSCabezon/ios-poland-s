//
//  OperatorMapper.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/12/2021.
//

import SANPLLibrary
import Foundation

public protocol OperatorMapping {
    func map(dto: OperatorDTO) -> Operator
}

public final class OperatorMapper: OperatorMapping {
    public init() {}
    
    public func map(dto: OperatorDTO) -> Operator {
        let topUpValuesDto = dto.topupValues
        let topUpValues = TopUpValues(type: topUpValuesDto.type,
                                      min: topUpValuesDto.min,
                                      max: topUpValuesDto.max,
                                      values: topUpValuesDto.values
                                        .map({ TopUpValue(value: $0.value, bonus: $0.bonus) })
                                        .sorted(by: { $0.value <= $1.value })
        )
        return Operator(id: dto.id, name: dto.name, topupValues: topUpValues, prefixes: dto.prefixes)
    }
}

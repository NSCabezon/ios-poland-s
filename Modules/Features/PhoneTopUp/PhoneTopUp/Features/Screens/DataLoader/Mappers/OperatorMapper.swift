//
//  OperatorMapper.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/12/2021.
//

import SANPLLibrary
import Foundation

public protocol OperatorMapping {
    func mapAndMerge(operatorDTOs: [OperatorDTO], gsmOperatorDTOs: [GSMOperatorDTO]) -> [Operator]
}

public final class OperatorMapper: OperatorMapping {
    public init() {}
    
    public func mapAndMerge(operatorDTOs: [OperatorDTO], gsmOperatorDTOs: [GSMOperatorDTO]) -> [Operator] {
        var results = [Operator]()
        for operatorDTO in operatorDTOs {
            let matchingGsmOperator = gsmOperatorDTOs.first(where: { $0.blueMediaId == "\(operatorDTO.id)" })
            let topUpValuesDto = operatorDTO.topupValues
            let topUpValues = TopUpValues(type: topUpValuesDto.type,
                                          min: topUpValuesDto.min,
                                          max: topUpValuesDto.max,
                                          values: (topUpValuesDto.values ?? [])
                                            .map({ TopUpValue(value: $0.value, bonus: $0.bonus) })
                                            .sorted(by: { $0.value <= $1.value })
                                          )
            let mobileOperator = Operator(id: operatorDTO.id,
                            name: matchingGsmOperator?.name ?? operatorDTO.name,
                            topupValues: topUpValues,
                            prefixes: operatorDTO.prefixes ?? [])
            results.append(mobileOperator)
        }
        
        return results
    }
}

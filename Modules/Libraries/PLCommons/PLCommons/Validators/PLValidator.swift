//
//  PLValidator.swift
//  PLCommons
//
//  Created by 189501 on 06/04/2022.
//

import Foundation

public protocol PLValidatorProtocol {
    
    func validateIdentificationNumber(_ number: String?) -> Result<Bool, PLIdentificationNumberError>
    
}

public class PLValidator: PLValidatorProtocol {
    
    public init() { }
    
    public func validateIdentificationNumber(_ number: String?) -> Result<Bool, PLIdentificationNumberError> {
        
        guard let number = number, !number.isEmpty else {
            return .failure(.empty)
        }
        
        let type: PLTaxIdentifierType = .NIP

        if !matches(regex: type.regex, value: number){
            return .failure(.illegalCharacter)
        }
        
        guard number.count == type.length else {
            return .failure(.invalidLength)
        }
        
        if !isChecksumValid(value: number, type: type) {
            return .failure(.invalidCheckSum)
        }
        
        return .success(true)
    }
    
    private func matches(regex: String, value: String) -> Bool {
        return value.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    private func isChecksumValid(value: String, type: PLTaxIdentifierType) -> Bool {
        guard let checksumIndex = type.checksumIndex,
              let moduloValue = type.moduloValue,
              let isComplementValue = type.isComplementValue
        else {
            return false
        }
        
        let checksumValue = value[checksumIndex]
        let controlSum = Int(checksumValue)

        var sum = 0
        
        for (index, _) in value.enumerated() {
            if let charValue = Int(value[index]),
               let weight = type.weights.element(atIndex: index) {
                sum += Int(charValue) * weight
            }
        }
        
        var control = sum % moduloValue
        
        if isComplementValue {
            control = type.complementValue - control
        }
        
        control = control % 10
        
        return control == controlSum
    }
    
}

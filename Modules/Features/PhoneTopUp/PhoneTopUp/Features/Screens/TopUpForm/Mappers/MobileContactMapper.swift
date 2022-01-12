//
//  MobileContactMapper.swift
//  PhoneTopUp
//
//  Created by 188216 on 23/12/2021.
//

import SANPLLibrary
import Foundation
import PLCommons

public protocol MobileContactMapping {
    func map(dto: PayeeDTO) -> MobileContact?
}

public final class MobileContactMapper: MobileContactMapping {
    public init() {}
    
    public func map(dto: PayeeDTO) -> MobileContact? {
        guard let payeePhoneNumber = dto.phone?.phoneNo  else {
            return nil
        }
        let fullName: String
        if let alias = dto.alias, !alias.isEmpty {
            fullName = alias
        } else {
            fullName = payeePhoneNumber
        }
        return MobileContact(fullName: fullName, phoneNumber: payeePhoneNumber)
    }
}

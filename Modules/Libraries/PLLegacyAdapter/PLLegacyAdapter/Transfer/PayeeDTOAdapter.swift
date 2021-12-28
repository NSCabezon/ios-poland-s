//
//  PayeeDTOAdapter.swift
//  Transfer
//
//  Created by Adrian Arcalá Ocón on 18/10/21.
//

import Foundation
import SANLegacyLibrary
import SANPLLibrary

final class PayeeDTOAdapter {
    static func adaptPayeeDTOtoCore(payeeDTO: SANPLLibrary.PayeeDTO) -> SANLegacyLibrary.PayeeDTO {
        var oldPayee = SANLegacyLibrary.PayeeDTO()
        oldPayee.beneficiaryBAOName = payeeDTO.alias ?? ""
        oldPayee.iban = IBANDTO(ibanString: payeeDTO.account?.accountNo ?? "")
        oldPayee.addressPayee = payeeDTO.account?.address ?? ""
        return oldPayee
    }
}

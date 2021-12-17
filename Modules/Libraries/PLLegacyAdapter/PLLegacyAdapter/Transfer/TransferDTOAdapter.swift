//
//  TransferDTOAdapter.swift
//  Transfer
//
//  Created by Adrian Arcalá Ocón on 18/10/21.
//

import Foundation
import SANLegacyLibrary
import SANPLLibrary

final class TransferDTOAdapter {
    static func adaptPayeeDTOtoTransferDTO(payeeDTO: SANPLLibrary.PayeeDTO) -> SANLegacyLibrary.PayeeDTO {
        var transferDTO = SANLegacyLibrary.PayeeDTO()
        transferDTO.beneficiaryBAOName = payeeDTO.alias ?? ""
        transferDTO.iban = IBANDTO(ibanString: payeeDTO.account?.accountNo ?? "")
        transferDTO.addressPayee = payeeDTO.account?.address ?? ""
        return transferDTO
    }
}

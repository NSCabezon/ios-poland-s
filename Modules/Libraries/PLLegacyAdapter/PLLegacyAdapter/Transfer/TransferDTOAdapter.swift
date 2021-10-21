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
    static func adaptPayeeDTOtoTransferDTO(payeeDTO: PayeeDTO) -> SANLegacyLibrary.TransferDTO {
        var transferDTO = SANLegacyLibrary.TransferDTO()
        transferDTO.beneficiaryBAOName = payeeDTO.alias ?? ""
        transferDTO.iban = IBANDTO(ibanString: payeeDTO.account?.accountNo ?? "")
        return transferDTO
    }
}

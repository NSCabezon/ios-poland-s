//
//  PLCesManagerApadater.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLCesManagerApadater {}
 
extension PLCesManagerApadater: BSANCesManager {
    func validateOTP(cardDTO: CardDTO, signatureWithTokenDTO: SignatureWithTokenDTO, phone: String) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmOTP(cardDTO: CardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
}

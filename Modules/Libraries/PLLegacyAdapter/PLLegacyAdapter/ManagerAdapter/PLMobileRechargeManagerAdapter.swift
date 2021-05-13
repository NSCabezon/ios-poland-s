//
//  PLMobileRechargeManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import Foundation
import SANLegacyLibrary

final class PLMobileRechargeManagerAdapter {}
 
extension PLMobileRechargeManagerAdapter: BSANMobileRechargeManager {
    func getMobileOperators(card: CardDTO) throws -> BSANResponse<MobileOperatorListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateMobileRecharge(card: CardDTO) throws -> BSANResponse<ValidateMobileRechargeDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateMobileRechargeOTP(card: CardDTO, signature: SignatureWithTokenDTO, mobile: String, amount: AmountDTO, mobileOperatorDTO: MobileOperatorDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmMobileRecharge(card: CardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
}

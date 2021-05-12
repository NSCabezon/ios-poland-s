//
//  PLOTPPushManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLOTPPushManagerAdapter {}
 
extension PLOTPPushManagerAdapter: BSANOTPPushManager {
    func requestDevice() throws -> BSANResponse<OTPPushDeviceDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateRegisterDevice(signature: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func registerDevice(otpValidation: OTPValidationDTO, otpCode: String, data: OTPPushConfirmRegisterDeviceInputDTO) throws -> BSANResponse<ConfirmOTPPushDTO> {
        return BSANErrorResponse(nil)
    }
    
    func updateTokenPush(currentToken: String, newToken: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateDevice(deviceToken: String) throws -> BSANResponse<OTPPushValidateDeviceDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getValidatedDeviceState() throws -> BSANResponse<ReturnCodeOTPPush> {
        return BSANErrorResponse(nil)
    }
}

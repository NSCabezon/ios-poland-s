//
//  PLSignatureAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

public final class PLSignatureAdapter {}

extension PLSignatureAdapter: SANLegacyLibrary.BSANSignatureManager {
    public func getCMCSignature() throws -> BSANResponse<SANLegacyLibrary.SignStatusInfo> {
        return BSANOkResponse(nil)
    }
    
    public func loadCMCSignature() throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func validateSignatureActivation() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func validateOTPOperability(newOperabilityInd: String, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANOkResponse(nil)
    }
    
    public func confimOperabilityChange(newOperabilityInd: String, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func confirmSignatureActivation(newSignature: String, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func confirmSignatureChange(newSignature: String, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func changePassword(oldPassword: String, newPassword: String) throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    public func consultPensionSignaturePositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func consultSendMoneySignaturePositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func consultCardsPayOffSignaturePositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func consultCashWithdrawalSignaturePositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func consultChangeSignSignaturePositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func consultScheduledSignaturePositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func consultCardLimitManagementPositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func requestOTPPushRegisterDevicePositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func consultBillAndTaxesSignaturePositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
    
    public func requestApplePaySignaturePositions() throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANOkResponse(nil)
    }
}

//
//  PLScaManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLScaManagerAdapter {}

extension PLScaManagerAdapter: BSANScaManager {
    public func checkSca() throws -> BSANResponse<CheckScaDTO> {
        return BSANOkResponse(nil)
    }
    
    public func loadCheckSca() throws -> BSANResponse<CheckScaDTO> {
        return BSANOkResponse(nil)
    }
    
    public func isScaOtpOkForAccounts() throws -> BSANResponse<Bool> {
        return BSANOkResponse(nil)
    }
    
    public func saveScaOtpLoginTemporaryBlock() throws {}
    
    public func saveScaOtpAccountTemporaryBlock() throws {}
    
    public func isScaOtpAskedForLogin() throws -> BSANResponse<Bool> {
        return BSANOkResponse(nil)
    }
    
    public func validateSca(forwardIndicator: Bool, foceSMS: Bool, operativeIndicator: ScaOperativeIndicatorDTO) throws -> BSANResponse<ValidateScaDTO> {
        return BSANOkResponse(nil)
    }
    
    public func confirmSca(tokenOTP: String?, ticketOTP: String?, codeOTP: String, operativeIndicator: ScaOperativeIndicatorDTO) throws -> BSANResponse<ConfirmScaDTO> {
        return BSANOkResponse(nil)
    }
}

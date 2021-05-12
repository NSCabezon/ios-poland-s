//
//  PLCashWithdrawalManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLCashWithdrawalManagerAdapter { }
 
extension PLCashWithdrawalManagerAdapter: BSANCashWithdrawalManager {
    
    func getCardDetailToken(cardDTO: CardDTO, cardTokenType: CardTokenType) throws -> BSANResponse<CardDetailTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validatePIN(cardDTO: CardDTO, cardDetailTokenDTO: CardDetailTokenDTO) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateOTP(cardDTO: CardDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmOTP(cardDTO: CardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?, amount: AmountDTO, trusteerInfo: TrusteerInfoDTO?) throws -> BSANResponse<CashWithDrawalDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getHistoricalWithdrawal(cardDTO: CardDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<HistoricalWithdrawalDTO> {
        return BSANErrorResponse(nil)
    }
    
}

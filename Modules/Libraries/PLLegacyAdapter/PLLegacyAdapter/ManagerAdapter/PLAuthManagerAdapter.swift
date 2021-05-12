//
//  PLAuthManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLAuthManagerAdapter { }
 
extension PLAuthManagerAdapter: BSANAuthManager {
    func authenticate(login: String, magic: String, loginType: SANLegacyLibrary.UserLoginType, isDemo: Bool) throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    func refreshToken() throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loginTouchId(footPrint: String, deviceToken: String, login: String, channelFrame: String, userType: SANLegacyLibrary.UserLoginType, isDemo: Bool, isPb: Bool) throws -> BSANResponse<TouchIdLoginDTO> {
        return BSANErrorResponse(nil)
    }
    
    func tryOauthLogin(bsanEnvironmentDTO: BSANEnvironmentDTO, tokenCredential: String) -> TokenOAuthDTO? {
        return nil
    }
    
    func logout() -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    func initSession(login: String, userType: SANLegacyLibrary.UserLoginType) {
    }
    
    func getAuthCredentials() throws -> SANLegacyLibrary.AuthCredentials {
        return SANLegacyLibrary.AuthCredentials(soapTokenCredential: "", apiTokenCredential: nil, apiTokenType: nil)
    }
    
    func requestOAuth() throws {
    }
    
}

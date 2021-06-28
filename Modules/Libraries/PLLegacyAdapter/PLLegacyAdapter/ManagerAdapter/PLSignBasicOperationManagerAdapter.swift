//
//  PLSignBasicOperationManagerAdapter.swift
//  PLLegacyAdapter

import SANLegacyLibrary

final class PLSignBasicOperationManagerAdapter {}

extension PLSignBasicOperationManagerAdapter: BSANSignBasicOperationManager {
    func getSignaturePattern() throws -> BSANResponse<GetSignPatternDTO> {
        return BSANErrorResponse(nil)
    }
    
    func startSignPattern(_ pattern: String, instaID: String) throws -> BSANResponse<SignBasicOperationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateSignPattern(_ input: SignValidationInputParams) throws -> BSANResponse<SignBasicOperationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getContractCmc() throws -> String {
        return ""
    }
    

}

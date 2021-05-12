//
//  PLInsurancesManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLInsurancesManagerAdapter {}
 
extension PLInsurancesManagerAdapter: BSANInsurancesManager {
    func getInsuranceData(contractId: String) throws -> BSANResponse<InsuranceDataDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getParticipants(policyId: String, familyId: String, thirdPartyInd: String, factoryPolicyNumber: String, contractId: String) throws -> BSANResponse<[InsuranceParticipantDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getBeneficiaries(policyId: String, familyId: String, thirdPartyInd: String, factoryPolicyNumber: String, contractId: String) throws -> BSANResponse<[InsuranceBeneficiaryDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getCoverages(policyId: String, familyId: String, thirdPartyInd: String, factoryPolicyNumber: String, contractId: String) throws -> BSANResponse<[InsuranceCoverageDTO]> {
        return BSANErrorResponse(nil)
    }
    
}

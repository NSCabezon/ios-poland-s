//
//  InsuranceDTOAdapter.swift
//  Account
//
//  Created by Ernesto Fernandez Calles on 14/2/22.
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary

final class InsuranceDTOAdapter {
    static func adaptPLInsuranceToInsurance(_ plInsurance: SANPLLibrary.InsuranceDTO) -> SANLegacyLibrary.InsuranceDTO {
        var insuranceDTO = SANLegacyLibrary.InsuranceDTO()
        insuranceDTO.contractDescription = plInsurance.policyName
        insuranceDTO.referenciaExterna = plInsurance.policyNumber
        insuranceDTO.detailsUrl = plInsurance.detailsUrl
        return insuranceDTO
    }

    static func getBaseUrl(dataProvider: BSANDataProvider) -> String? {
        return try? dataProvider.getEnvironment().urlBase
    }
}


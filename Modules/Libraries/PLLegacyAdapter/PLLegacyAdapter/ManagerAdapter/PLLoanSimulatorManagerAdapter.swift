//
//  PLLoanSimulatorManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLLoanSimulatorManagerAdapter {}
 
extension PLLoanSimulatorManagerAdapter: BSANLoanSimulatorManager {
    func getActiveCampaigns() throws -> BSANResponse<CampaignsCheckLoanSimulatorDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadLimits(input: LoadLimitsInput, selectedCampaignCurrency: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getLimits() throws -> BSANResponse<LoanSimulatorProductLimitsDTO> {
        return BSANErrorResponse(nil)
    }
    
    func doSimulation(inputData: LoanSimulatorDataSend) throws -> BSANResponse<LoanSimulatorConditionsDTO> {
        return BSANErrorResponse(nil)
    }
}

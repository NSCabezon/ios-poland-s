//
//  PLPensionsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLPensionsManagerAdapter {}
 
extension PLPensionsManagerAdapter: BSANPensionsManager {
    func getPensionTransactions(forPension pension: PensionDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<PensionTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getPensionDetail(forPension pension: PensionDTO) throws -> BSANResponse<PensionDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getPensionContributions(pensionDTO: PensionDTO, pagination: PaginationDTO?) throws -> BSANResponse<PensionContributionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAllPensionContributions(pensionDTO: PensionDTO) throws -> BSANResponse<PensionContributionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getClausesPensionMifid(pensionDTO: PensionDTO, pensionInfoOperationDTO: PensionInfoOperationDTO, amountDTO: AmountDTO) throws -> BSANResponse<PensionMifidDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmExtraordinaryContribution(pensionDTO: PensionDTO, amountDTO: AmountDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPeriodicalContribution(pensionDTO: PensionDTO, pensionContributionInput: PensionContributionInput, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func changePensionAlias(_ pension: PensionDTO, newAlias: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
}

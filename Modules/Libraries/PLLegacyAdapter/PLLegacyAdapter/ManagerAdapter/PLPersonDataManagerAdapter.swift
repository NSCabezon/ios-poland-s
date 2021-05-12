//
//  PLPersonDataManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import Foundation
import SANLegacyLibrary

final class PLPersonDataManagerAdapter {}
 
extension PLPersonDataManagerAdapter: BSANPersonDataManager {
    func loadBasicPersonData() throws -> BSANResponse<PersonBasicDataDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadPersonDataList(clientDTOs: [ClientDTO]) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getPersonData(accountDTO: AccountDTO) throws -> BSANResponse<PersonDataDTO> {
        return BSANErrorResponse(nil)
    }
    
}

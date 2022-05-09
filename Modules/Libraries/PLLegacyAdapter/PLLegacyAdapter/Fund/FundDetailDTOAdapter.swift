//
//  FundDetailDTOAdapter.swift
//  Account
//
//  Created by Ernesto Fernandez Calles on 14/3/22.
//

import SANLegacyLibrary
import SANPLLibrary

final class FundDetailDTOAdapter {

    static func adaptPLFundDetailToFundDetail(_ plFund: SANPLLibrary.FundDetailsDTO) -> SANLegacyLibrary.FundDetailDTO {
        var fundDetailDTO = SANLegacyLibrary.FundDetailDTO()
        return fundDetailDTO
    }
}

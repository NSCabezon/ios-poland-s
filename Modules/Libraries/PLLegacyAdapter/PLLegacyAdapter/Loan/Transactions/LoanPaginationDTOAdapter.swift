//
//  LoanPaginationDTOAdapter.swift
//  PLLegacyAdapter
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary

final class LoanPaginationDTOAdapter {
    static func adaptPLLoanPaginationToLoanPagination(_ plLoanPagination: SANPLLibrary.LoanPageDTO) -> SANLegacyLibrary.PaginationDTO {
        var loanPaginationDTO = SANLegacyLibrary.PaginationDTO()
        loanPaginationDTO.endList = !(plLoanPagination.hasNextPage ?? false)
        return loanPaginationDTO
    }
}


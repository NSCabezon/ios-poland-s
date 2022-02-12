//
//  PLDepositsManagerApadater.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary
import CoreFoundationLib
import CoreDomain

final class PLDepositsManagerAdapter {
	private let depositManager: PLDepositManagerProtocol
	private let bsanDataProvider: BSANDataProvider

	init(depositManager: PLDepositManagerProtocol, bsanDataProvider: BSANDataProvider) {
		self.bsanDataProvider = bsanDataProvider
		self.depositManager = depositManager
	}
}

extension PLDepositsManagerAdapter: BSANDepositsManager {
    func getDepositImpositionsTransactions(depositDTO: SANLegacyLibrary.DepositDTO, pagination: PaginationDTO?) throws -> BSANResponse<ImpositionsListDTO> {
        return BSANErrorResponse(nil)
    }

    func getImpositionTransactions(impositionDTO: ImpositionDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<ImpositionTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }

    func getImpositionLiquidations(impositionDTO: ImpositionDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<LiquidationTransactionListDTO> {
        return BSANErrorResponse(nil)
    }

    func getLiquidationDetail(impositionDTO: ImpositionDTO, liquidationDTO: LiquidationDTO) throws -> BSANResponse<LiquidationDetailDTO> {
        return BSANErrorResponse(nil)
    }

    func changeDepositAlias(_ deposit: SANLegacyLibrary.DepositDTO, newAlias: String) throws -> BSANResponse<Void> {
        let result = try? depositManager.changeAlias(depositDTO: deposit, newAlias: newAlias)

		switch result {
		case .success: return BSANOkResponse(nil)
		default: return BSANErrorResponse(nil)
		}
    }
}

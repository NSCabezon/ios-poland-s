//
//  SavingsDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez Mesa on 29/3/22.
//

import SANPLLibrary
import SANLegacyLibrary
import CoreFoundationLib
import PLCommons

final class SavingsDTOAdapter {
    static func adaptPLSavingsToSavings(_ saving: SANPLLibrary.SavingDTO) -> SANLegacyLibrary.SavingProductDTO {
        var savingDTO = SANLegacyLibrary.SavingProductDTO()
        savingDTO.accountId = saving.accountId?.id ?? ""
        savingDTO.identification = IBANFormatter.format(iban: saving.number)
        savingDTO.alias = saving.name?.userDefined ?? ""
        let currency = CurrencyDTO(currencyName: saving.currencyCode ?? "", currencyType: CurrencyType.parse(saving.currencyCode))
        savingDTO.currentBalance = AmountDTO(value: saving.currentBalance?.value ?? 0, currency: currency)
        savingDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: saving.accountId?.id ?? "", contractNumber: saving.number)
        savingDTO.currency = currency
        savingDTO.ownershipTypeDesc = (saving.role == SavingDTO.SavingRoleDTO.owner.rawValue) ? .owner : .none
        savingDTO.accountSubType = saving.type
        if let interestRateData = saving.interestRateData {
            savingDTO.interestRate = interestRateData.interestRateIndicator == .value ? interestRateData.interestRate.stringValue : nil
            savingDTO.interestRateLink = interestRateData.interestRateIndicator == .url ? InterestRateLinkDTO(title: localized("generic_button_seeDetails"), url: interestRateData.interestRateURL ?? "") : nil
        }
        return savingDTO
    }
}

private extension Decimal {
    var stringValue: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .percent
        formatter.multiplier = 1
        return formatter.string(for: self) ?? ""
    }
}

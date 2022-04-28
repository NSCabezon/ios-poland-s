//
//  TaxTransferSummaryMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 06/04/2022.
//

import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol TaxTransferSummaryMapping {
    func map(with confirmationTransferDto: ConfirmationTransferDTO) -> TaxTransferSummary
}

final class TaxTransferSummaryMapper: TaxTransferSummaryMapping {
    func map(with confirmationTransferDto: ConfirmationTransferDTO) -> TaxTransferSummary {
        let formatter = DateFormatter()
        formatter.dateFormat = TimeFormat.yyyyMMdd.rawValue
        let date = formatter.date(from: confirmationTransferDto.valueDate ?? "")
        let formattedString = date?.toString(format: PLTimeFormat.ddMMyyyyDotted.rawValue)
        let amount = abs(Decimal(confirmationTransferDto.debitAmountData?.amount ?? 0))
        let currency = CurrencyType(rawValue: confirmationTransferDto.debitAmountData?.currency ?? CurrencyType.złoty.name)
        let accountNumber = IBANFormatter.format(iban: confirmationTransferDto.debitAccountData?.accountNo)
        let recipientAccountNumber = IBANFormatter.format(iban: confirmationTransferDto.creditAccountData?.accountNo)
        return .init(
            amount: amount,
            currency: currency ?? .złoty,
            title: confirmationTransferDto.title ?? "",
            accountName: confirmationTransferDto.debitAccountData?.accountName ?? "",
            accountNumber: accountNumber,
            recipientName: confirmationTransferDto.creditAccountData?.accountName ?? "",
            recipientAccountNumber: recipientAccountNumber,
            dateString: formattedString ?? "",
            transferType: AcceptDomesticTransactionParameters.TransferType(
                rawValue: confirmationTransferDto.transferType ?? ""
            )
        )
    }
}

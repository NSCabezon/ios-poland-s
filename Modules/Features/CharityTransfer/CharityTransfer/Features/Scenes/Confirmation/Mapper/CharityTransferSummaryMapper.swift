import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol CharityTransferSummaryMapping {
    func map(with confirmationTransferDto: ConfirmationTransferDTO) -> CharityTransferSummary
}

final class CharityTransferSummaryMapper: CharityTransferSummaryMapping {

    func map(with confirmationTransferDto: ConfirmationTransferDTO) -> CharityTransferSummary {
        let formatter = DateFormatter()
        formatter.dateFormat = TimeFormat.yyyyMMdd.rawValue
        let date = formatter.date(from: confirmationTransferDto.valueDate ?? "")
        let formattedString = date?.toString(format: PLTimeFormat.ddMMyyyyDotted.rawValue)
        let amount = abs(Decimal(confirmationTransferDto.debitAmountData?.amount ?? 0))
        let currency = CurrencyType(rawValue: confirmationTransferDto.debitAmountData?.currency ?? CurrencyType.złoty.name)
        let accountNumber = IBANFormatter.format(iban: confirmationTransferDto.debitAccountData?.accountNo)
        return .init(
            amount: amount,
            currency: currency ?? .złoty,
            title: confirmationTransferDto.title ?? "",
            accountName: confirmationTransferDto.debitAccountData?.accountName ?? "",
            accountNumber: accountNumber,
            recipientName: confirmationTransferDto.creditAccountData?.accountName ?? "",
            dateString: formattedString ?? "",
            transferType: AcceptDomesticTransactionParameters.TransferType(
                rawValue: confirmationTransferDto.transferType ?? ""
            )
        )
    }
}

import Foundation
import Commons
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol MobileTransferSummaryMapping {
    func map(summary: AcceptDomesticTransferSummaryDTO,
             transferType: AcceptDomesticTransactionParameters.TransferType) -> MobileTransferSummary
}

final class MobileTransferSummaryMapper: MobileTransferSummaryMapping {

    func map(summary: AcceptDomesticTransferSummaryDTO,
             transferType: AcceptDomesticTransactionParameters.TransferType) -> MobileTransferSummary {
        
        let formatter = DateFormatter()
        formatter.dateFormat = TimeFormat.yyyyMMdd.rawValue
        let date = formatter.date(from: summary.valueDate ?? "")
        let formattedString = date?.toString(format: "dd.MM.yyyy")

        return .init(amount: abs(summary.debitAmountData.amount ?? 0),
                     currency: CurrencyType(rawValue: summary.debitAmountData.currency ?? CurrencyType.złoty.name) ?? CurrencyType.złoty,
                     title: summary.title,
                     accountName: summary.debitAccountData.accountName ?? "",
                     accountNumber: IBANFormatter.format(iban: summary.debitAccountData.accountNo),
                     recipientName: summary.creditAccountData.accountName ?? "",
                     recipientNumber: formattedPhoneNumber(summary.dstPhoneNo ?? ""),
                     dateString: formattedString ?? "",
                     transferType: transferType)
    }

    private func formattedPhoneNumber(_ number: String) -> String {
        let msisdnPhoneFormatter = MSISDNPhoneNumberFormatter()
        let numberWithPrefix =  msisdnPhoneFormatter.polishCountryCodeAppendedNumber(formattedNumber: FormattedNumberMetadata(formattedNumber: number, unformattedNumber: number))?.formattedNumber
        
        return PLPhoneNumberTextFieldFormatter().formatStrnig(numberInString: numberWithPrefix ?? "")
    }
}

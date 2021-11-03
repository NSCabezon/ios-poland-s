//
//  RecentRecipientsDTO.swift
//  SANPLLibrary
//
//  Created by Luis Escámez Sánchez on 1/10/21.
//

import Foundation
import CoreDomain
import SANLegacyLibrary

struct RecentRecipientsDTO: Codable {
    let recentRecipientsData: [RecentRecipientsDataDTO]?
}

struct RecentRecipientsDataDTO: Codable {
    let accountNo: String?
    let accountName: String?
    let amount: Decimal?
    let currency: String?
    let title: String?
    let postingDate: String?
}

extension RecentRecipientsDataDTO: TransferRepresentable {
    var number: IBANRepresentable? {
        guard let iban = self.accountNo else {
            return nil
        }
        return IBANDTO(ibanString: iban)
    }
    
    var name: String? {
        self.accountName
    }
    
    var transferConcept: String? {
        self.title
    }
    
    var typeOfTransfer: TransferRepresentableType? {
        self.getTransferType(self.amount ?? 0)
    }
    
    var scheduleType: TransferRepresentableScheduleType? {
        nil
    }
    
    var amountRepresentable: AmountRepresentable? {
        let amount = self.amount
        return self.makeAmountDTO(value: amount ?? 0, currencyCode: self.currency)
    }
    
    var transferExecutedDate: Date? {
        self.postingDateToDate(self.postingDate ?? "")
    }
}

private extension RecentRecipientsDataDTO {
    func makeAmountDTO(value: Decimal, currencyCode: String?) -> AmountDTO? {
        guard let currencyCode = currencyCode else {
            return nil
        }
        let currencyType: CurrencyType = CurrencyType.parse(currencyCode)
        let balanceAmount = value
        let currencyDTO = CurrencyDTO(currencyName: currencyCode, currencyType: currencyType)
        return AmountDTO(value: balanceAmount, currency: currencyDTO)
    }
    
    func getTransferType(_ amount: Decimal) -> TransferRepresentableType? {
        return amount < 0 ? .emitted : .received
    }
    
    func postingDateToDate(_ postingDate: String) -> Date? {
        guard let dateFormatted = DateFormats.toDate(string: postingDate, output: .YYYYMMDD) else { return nil }
        return dateFormatted
    }
}

import Foundation
import SANPLLibrary
import SANLegacyLibrary

protocol TransactionMapping {
    func map(dto: GetTrnToConfDTO) throws -> Transaction
}

final class TransactionMapper: TransactionMapping {
    enum Error: LocalizedError {
        case wrongDateFormat
    }
}

extension TransactionMapper {
    func map(dto: GetTrnToConfDTO) throws -> Transaction {
        let date = DateFormats.toDate(string: dto.date, output: .YYYYMMDD)
        let timeDate = DateFormats.toDate(string: dto.time, output: .YYYYMMDD_HHmmssSSSZ)
        
        guard let transferType = Transaction.TransferType(rawValue: dto.transferType.rawValue) else {
            throw Error.wrongDateFormat
        }

        return Transaction(transactionId: dto.trnId,
                           title: dto.title,
                           date: date,
                           time: timeDate,
                           transferType: transferType,
                           placeName: dto.merchant?.shortName,
                           address: dto.merchant?.address,
                           city: dto.merchant?.city,
                           amount: dto.amount.amount)
        
    }
}

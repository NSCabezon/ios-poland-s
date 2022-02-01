//
//  ChequeModelMapper.swift
//  Pods
//
//  Created by Piotr Mielcarzewicz on 22/06/2021.
//

import CoreFoundationLib
import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLCommons

protocol ChequeModelMapping {
    func map(dto: BlikChequeDTO) throws -> BlikCheque
}

final class ChequeModelMapper {
    enum Error: LocalizedError {
        case wrongDateFormat
        case unexpectedStatus

        var errorDescription: String? {
            switch self {
            case .wrongDateFormat, .unexpectedStatus:
                return "#Bląd przetwarzania danych"
            }
        }
    }
    
    private var dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
}

extension ChequeModelMapper: ChequeModelMapping {
    func map(dto: BlikChequeDTO) throws -> BlikCheque {
        guard let creationDate = dateFormatter.date(from: dto.ticketData.createTime),
              let expirationDate = dateFormatter.date(from: dto.ticketData.expiryTime) else {
            throw ChequeModelMapper.Error.wrongDateFormat
        }
        
        return BlikCheque(
            id: dto.authCodeId,
            ticketCode: dto.ticketData.ticket,
            title: dto.ticketData.name,
            value: Money(amount: Decimal(dto.ticketData.amount), currency: dto.ticketData.currency),
            creationDate: creationDate,
            expirationDate: expirationDate,
            status: try getStatus(of: dto)
        )
    }
    
    private func getStatus(of cheque: BlikChequeDTO) throws -> BlikCheque.Status {
        switch cheque.ticketData.status {
        case "ACTIVE":
            return .active
        case "REALIZED":
            guard let usedAmount = cheque.transaction.amount else {
                return .executed(nil)
            }
            let amount = Money(
                amount: Decimal(usedAmount),
                currency: cheque.ticketData.currency
            )
            return .executed(amount)
        case "OVERDUE":
            return .expired
        case "CANCELLED":
            return .canceled
        case "REJECTED":
            return .rejected
        default:
            throw Error.unexpectedStatus
        }
    }
}

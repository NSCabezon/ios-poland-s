//
//  PLGetCardTransactionDetailViewConfigurationUseCase.swift
//  Santander
//
//  Created by Hernán Villamil on 11/5/22.
//

import Foundation
import Cards
import CoreDomain
import OpenCombine
import CoreFoundationLib

final class PLGetCardTransactionDetailViewConfigurationUseCase {}

extension PLGetCardTransactionDetailViewConfigurationUseCase: GetCardTransactionDetailViewConfigurationUseCase {
    func fetchCardTransactionDetailViewConfiguration(transaction: CardTransactionRepresentable, detail: CardTransactionDetailRepresentable?) -> AnyPublisher<[CardTransactionDetailViewConfigurationRepresentable], Never> {
        let configuration = getConfiguration(transaction: transaction,
                                             detail: detail)
        return Just(configuration)
            .eraseToAnyPublisher()
    }
}


private extension PLGetCardTransactionDetailViewConfigurationUseCase {
    func getConfiguration(transaction: CardTransactionRepresentable,
                          detail: CardTransactionDetailRepresentable?) -> [CardTransactionDetailViewConfigurationRepresentable] {

        let operationDateView = getOperationDateView(transaction: transaction)
        let statusDetailView = getStatusDetailView(transaction: transaction)
        let firstColumn = CardTransactionDetailViewConfiguration(left: operationDateView,
                                                                 right: statusDetailView)
        let annotationView = getAnnotationDateView(transaction: transaction)
        let recipientView = getRecipientView(transaction: transaction)
        let secondColumn = CardTransactionDetailViewConfiguration(left: annotationView,
                                                                 right: recipientView)
        let cardAccountView = getCardAccountView(transaction: transaction)
        let thirdColumn = CardTransactionDetailViewConfiguration(left: cardAccountView,
                                                                 right: nil)
        let operationTypeView = getOperationTypeView(transaction: transaction)
        let fourthColumn = CardTransactionDetailViewConfiguration(left: operationTypeView,
                                                                 right: nil)
        return [firstColumn, secondColumn, thirdColumn, fourthColumn]
    }
    
    func getOperationDateView(transaction: CardTransactionRepresentable) -> CardTransactionDetailView {
        var sourceDate: String? = ""
        if let date = transaction.sourceDate {
            sourceDate = dateFrom(dateStr: date)
        }
        return CardTransactionDetailView(title: localized("transaction_label_operationDate"),
                                         value: sourceDate ?? "",
                                         accessibilityLabel: AccessibilityCardTransactionsDetail.operartionDate.rawValue)
    }
    
    func getStatusDetailView(transaction: CardTransactionRepresentable) -> CardTransactionDetailView {
        return CardTransactionDetailView(title: localized("transaction_label_statusDetail"),
                                         value: localized(transaction.stateTitle ?? ""),
                                         accessibilityLabel: AccessibilityCardTransactionsDetail.status.rawValue)
    }
    
    func getAnnotationDateView(transaction: CardTransactionRepresentable) -> CardTransactionDetailView {
        var postedDate: String? = ""
        if let date = transaction.postedDate {
            postedDate = dateFrom(dateStr: date)
        }
        return CardTransactionDetailView(title: localized("transaction_label_annotationDate"),
                                         value: postedDate ?? "",
                                         accessibilityLabel: AccessibilityCardTransactionsDetail.annotationDate.rawValue)
    }
    
    func getRecipientView(transaction: CardTransactionRepresentable) -> CardTransactionDetailView {
        return CardTransactionDetailView(title: localized("transaction_label_recipient"),
                                         value: transaction.recipient ?? "",
                                         accessibilityLabel: AccessibilityCardTransactionsDetail.recipient.rawValue)
    }
    
    func getCardAccountView(transaction: CardTransactionRepresentable) -> CardTransactionDetailView {
        return CardTransactionDetailView(title: localized("transaction_label_cardAccountNumber"),
                                  value: accountNumber(str: transaction.cardAccountNumber ?? ""),
                                         accessibilityLabel: AccessibilityCardTransactionsDetail.cardNumber.rawValue)
    }
    
    func getOperationTypeView(transaction: CardTransactionRepresentable) -> CardTransactionDetailView {
        return CardTransactionDetailView(title: localized("transaction_label_operationType"),
                                         value: transaction.operationType?.capitalized ?? "",
                                         accessibilityLabel: AccessibilityCardTransactionsDetail.type.rawValue)
    }
}

private extension PLGetCardTransactionDetailViewConfigurationUseCase {
    func dateFrom(dateStr: String) -> String? {
        let date =  dateFromString(input: dateStr, inputFormat: .yyyyMMdd)
        let dateStr = dateToString(date: date, outputFormat: .dd_MMM_yyyy) ?? ""
        return dateStr
    }
    
    func accountNumber(str: String) -> String {
        var str = str
        str.insert(" ", at: str.index(str.startIndex, offsetBy: 4))
        str.insert(" ", at: str.index(str.startIndex, offsetBy: 9))
        str.insert(" ", at: str.index(str.startIndex, offsetBy: 12))
        return str
    }
}

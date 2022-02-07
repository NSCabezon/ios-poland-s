//
//  ChequeDetailsViewModelMapper.swift
//  BLIK
//
//  Created by 186491 on 22/06/2021.
//

import CoreFoundationLib

protocol ChequeDetailsViewModelMapperProtocol {
    func map(cheque: BlikCheque) -> ChequeDetailsViewModel
}

final class ChequeDetailsViewModelMapper: ChequeDetailsViewModelMapperProtocol {
    private let dateFormat = "dd.MM.yyyy HH:mm"
    private let amountFormatter: NumberFormatter
    
    init(amountFormatter: NumberFormatter) {
        self.amountFormatter = amountFormatter
    }
    
    func map(cheque: BlikCheque) -> ChequeDetailsViewModel {
        amountFormatter.currencySymbol = cheque.value.currency
        
        var items = [
            ChequeDetailsViewModel.Item(
                name: localized("pl_blik_label_chequeNumber"),
                value: cheque.ticketCode.separate(every: 3, with: " ")
            ),
            ChequeDetailsViewModel.Item(
                name: localized("pl_blik_label_ChequeAmount"),
                value: amountFormatter.string(for: cheque.value.amount) ?? "\(cheque.value.amount) \(cheque.value.currency)"
            ),
            ChequeDetailsViewModel.Item(
                name: localized("pl_blik_label_chequeTermUntil"),
                value: cheque.expirationDate.toString(format: dateFormat)
            ),
            ChequeDetailsViewModel.Item(
                name: localized("pl_blik_label_createdTerm"),
                value: cheque.creationDate.toString(format: dateFormat)
            )
        ]
        
        switch cheque.status {
        case .active:
            items.append(
                ChequeDetailsViewModel.Item(
                    name: localized("pl_blik_label_chequeStatus"),
                    value: localized("pl_blik_text_chequeStatus_active")
                )
            )
        case .canceled:
            items.append(
                ChequeDetailsViewModel.Item(
                    name: localized("pl_blik_label_chequeStatus"),
                    value: localized("pl_blik_text_chequeStatus_deleted")
                )
            )
        case .rejected:
            items.append(
                ChequeDetailsViewModel.Item(
                    name: localized("pl_blik_label_chequeStatus"),
                    value: localized("pl_blik_text_chequeStatus_rejected")
                )
            )
        case .expired:
            items.append(
                ChequeDetailsViewModel.Item(
                    name: localized("pl_blik_label_chequeStatus"),
                    value: localized("pl_blik_text_chequeStatus_expired")
                )
            )
        case let .executed(money):
            if let money = money {
                amountFormatter.currencySymbol = money.currency
                items.insert(
                    ChequeDetailsViewModel.Item(
                        name: localized("pl_blik_label_chequeAmountUsed"),
                        value: amountFormatter.string(for: money.amount) ?? "\(money.amount) \(money.currency)"
                    ),
                    at: 2
                )
            }
            items.append(
                ChequeDetailsViewModel.Item(
                    name: localized("pl_blik_label_chequeStatus"),
                    value: localized("pl_blik_text_chequeStatus_used")
                )
            )
        }
        
        let chequeName: String = {
            if cheque.title.isEmpty {
                return cheque.ticketCode.separate(every: 3, with: " ")
            } else {
                return cheque.title
            }
        }()
        
        return ChequeDetailsViewModel(
            chequeName: chequeName,
            items: items,
            shouldShowFooter: (cheque.status == .active)
        )
    }
}

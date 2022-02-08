//
//  ChequeViewModelMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/06/2021.
//

import CoreFoundationLib
import UI

protocol ChequeViewModelMapperProtocol {
    func map(cheques: [BlikCheque], listType: ChequeListType) -> ChequeViewModelType
}

final class ChequeViewModelMapper: ChequeViewModelMapperProtocol {
    private let amountFormatter: NumberFormatter
    
    init(amountFormatter: NumberFormatter) {
        self.amountFormatter = amountFormatter
    }
    
    func map(cheques: [BlikCheque], listType: ChequeListType) -> ChequeViewModelType {
        let viewModels = cheques.map { cheque -> ChequeViewModel in
            amountFormatter.currencySymbol = cheque.value.currency
            let chequeTitle: String = {
                if cheque.title.isEmpty  {
                    return cheque.ticketCode.separate(every: 3, with: " ")
                } else {
                    return cheque.title
                }
            }()
            return ChequeViewModel(
                id: cheque.id,
                title: chequeTitle,
                amount: amountFormatter.string(for: cheque.value.amount) ?? "\(cheque.value.amount) \(cheque.value.currency)"
            )
        }
        
        if viewModels.isEmpty {
            return .emptyDataMessage(emptyDataViewModel(for: listType))
        } else {
            return .cheques(viewModels)
        }
    }
    
    private func emptyDataViewModel(for type: ChequeListType) -> EmptyDataMessageViewModel {
        switch type {
        case .active:
            return EmptyDataMessageViewModel(
                titleLocalizableKey: "pl_blik_title_noActivCheque",
                messageLocalizableKey: localized("pl_blik_text_noActivCheque"),
                titleFontType: .regular
            )
        case .archived:
            return EmptyDataMessageViewModel(
                titleLocalizableKey: "pl_blik_text_noArchiveCheque",
                messageLocalizableKey: nil,
                titleFontType: .regular
            )
        }
    }
}

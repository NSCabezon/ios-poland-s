//
//  SendMoneyTransferTypeFeeViewModel.swift
//  Santander
//
//  Created by Angel Abad Perez on 26/10/21.
//

import Models
import Commons
import CoreDomain

final class SendMoneyTransferTypeFeeViewModel {
    private let amount: AmountRepresentable
    let status: OneStatus
    
    init?(amount: AmountRepresentable?,
         status: OneStatus) {
        guard let amount = amount else { return nil }
        self.amount = amount
        self.status = status
    }
}

extension SendMoneyTransferTypeFeeViewModel {
    var formattedAmount: NSAttributedString? {
        let primaryFont = UIFont.typography(fontName: .oneH300Regular)
        let decimalFont = UIFont.typography(fontName: .oneB400Regular)
        let decorator = AmountRepresentableDecorator(self.amount,
                                                     font: primaryFont,
                                                     decimalFont: decimalFont)
        return decorator.getFormatedCurrency()
    }
}

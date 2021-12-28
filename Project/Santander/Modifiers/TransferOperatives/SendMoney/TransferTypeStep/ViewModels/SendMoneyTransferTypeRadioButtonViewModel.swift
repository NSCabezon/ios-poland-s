//
//  SendMoneyTransferTypeRadioButtonViewModel.swift
//  Santander
//
//  Created by Angel Abad Perez on 26/10/21.
//

import CoreFoundationLib

final class SendMoneyTransferTypeRadioButtonViewModel {
    let oneRadioButtonViewModel: OneRadioButtonViewModel
    let feeViewModel: SendMoneyTransferTypeFeeViewModel?
    
    init(oneRadioButtonViewModel: OneRadioButtonViewModel,
         feeViewModel: SendMoneyTransferTypeFeeViewModel? = nil) {
        self.oneRadioButtonViewModel = oneRadioButtonViewModel
        self.feeViewModel = feeViewModel
    }
}

//
//  PhoneTransferRegistrationFormViewModel.swift
//  BLIK
//
//  Created by 186491 on 22/07/2021.
//

import Commons

struct PhoneTransferRegistrationFormViewModel {
    let hintMessage: String
    let accountViewModel: AccountViewModel
    let phoneViewModel: PhoneViewModel
    let statementViewModel: StatementViewModel

    struct AccountViewModel {
        let title: String
        let accountName: String
        let availableFunds: String
        let accountNumber: String
    }
    
    struct PhoneViewModel {
        let title: String
        let phoneNumber: String
    }
    
    struct StatementViewModel {
        let title: String
        let description: LocalizedStylableText
    }
}

//
//  PLDomesticTransactionParametersInput.swift
//  SANPLLibrary
//
//  Created by 187830 on 05/11/2021.
//

public struct PLDomesticTransactionParametersInput {
    let debitAccountNumber: String
    let creditAccountNumber: String
    let debitAmount: Decimal
    let userID: String
    
    public init(debitAccountNumber: String,
                creditAccountNumber: String,
                debitAmount: Decimal,
                userID: String
    ) {
        self.debitAccountNumber = debitAccountNumber
        self.creditAccountNumber = creditAccountNumber
        self.debitAmount = debitAmount
        self.userID = userID
    }
}

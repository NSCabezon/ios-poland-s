//
//  PLDomesticTransactionParametersGenerable.swift
//  SANPLLibrary
//
//  Created by 187830 on 05/11/2021.
//

public protocol PLDomesticTransactionParametersGenerable {
    func getParameters(
        transactionParametersInput: PLDomesticTransactionParametersInput,
        type: PLDomesticTransactionParametersType
    ) -> String
}


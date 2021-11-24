//
//  CreditCardRepaymentFormManagerMock.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 15/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Commons
import SANPLLibrary
import SANLegacyLibrary
@testable import CreditCardRepayment

final class CreditCardRepaymentFormManagerFactoryMock {
    static func make(dependenciesResolver: DependenciesResolver) -> CreditCardRepaymentFormManagerMock {
        let useCase = dependenciesResolver.resolve(for: CreateCreditCardRepaymentFormUseCaseProtocol.self)
        let formManager = CreditCardRepaymentFormManagerMock()
        if let output = try? useCase.executeUseCase(requestValues: .init(creditCardEntity: nil)).getOkResult() {
            formManager.initialSetup(
                form: output.form,
                steps: output.steps,
                accountSelectionPossible: output.accountSelectionPossible,
                currency: output.currency
            )
        }
        return formManager
    }
}


class CreditCardRepaymentFormManagerMock: CreditCardRepaymentFormManager {
    
    var onSetSummary: (CreditCardRepaymentSummary) -> Void = { _ in }
    
    override func setSummary(_ summary: CreditCardRepaymentSummary) {
        super.setSummary(summary)
        onSetSummary(summary)
    }
}

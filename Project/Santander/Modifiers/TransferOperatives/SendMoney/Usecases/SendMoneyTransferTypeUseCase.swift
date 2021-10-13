//
//  CommisionSendMoneyUseCase.swift
//  Santander
//
//  Created by José Norberto Hidalgo Romero on 5/10/21.
//

import SANLegacyLibrary
import DomainCommon
import Commons
import Operative
import Models
import CoreDomain
import TransferOperatives

final class SendMoneyTransferTypeUseCase: UseCase<SendMoneyTransferTypeUseCaseInput, SendMoneyTransferTypeUseCaseOutput, StringErrorOutput> {
    
    let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: SendMoneyTransferTypeUseCaseInput) throws -> UseCaseResponse<SendMoneyTransferTypeUseCaseOutput, StringErrorOutput> {
        //TODO: Get if recipient account is internal
        let internalRecipientAccount: Bool = true
        if internalRecipientAccount {
            //TODO: Ask for POEditor string
            let commisionStaticText: String = localized("transfer_subtype_static_text")
            return .ok(.transferTypeInfo(commisionStaticText))
        } else {
            let defaultCurrency = NumberFormattingHandler.shared.getDefaultCurrencyText()
            let originAccountCurrency = requestValues.sourceAccount.currencyName
            let destinationAccountCurrency = requestValues.destinationAccount.currencyName
            if (originAccountCurrency == defaultCurrency) {
                let subtypeOne = TransferTypeContent(name: "type 1", description: "", commision: nil, tax: nil, total: nil)
                //TODO: Call API1 to get availability of types A/8
                //TODO: Call API2 to get final fees
                return .ok(.transferTypeList([subtypeOne]))
            } else {
                if (destinationAccountCurrency == defaultCurrency) {
                    //TODO: Ask API2 for final fees (out of MVP)
                } else {
                    let subtypeZero = TransferTypeContent(name: "type 0", description: "", commision: nil, tax: nil, total: nil)
                    return .ok(.transferTypeList([subtypeZero]))
                }
            }
        }
    }
}

struct SendMoneyTransferTypeUseCaseInput {
    public let sourceAccount: AccountRepresentable
    public let destinationAccount: AccountRepresentable
    public let transfer: GenericTransferInputRepresentable
}

enum SendMoneyTransferTypeUseCaseOutput {
    case transferTypeInfo(String)
    case transferTypeList([TransferTypeContent])
}

struct TransferTypeContent {
    public let name: String
    public let description: String
    public var commision: AmountRepresentable?
    public var tax: AmountRepresentable?
    public var total: AmountRepresentable?
}

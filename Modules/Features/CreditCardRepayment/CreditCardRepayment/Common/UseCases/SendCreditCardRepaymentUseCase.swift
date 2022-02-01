import Foundation
import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary

protocol SendCreditCardRepaymentProtocol: UseCase<SendCreditCardRepaymentUseCaseInput,
                                                  SendCreditCardRepaymentUseCaseOkOutput,
                                                  SendCreditCardRepaymentUseCaseErrorOutput> {}

final class SendCreditCardRepaymentUseCase: UseCase<SendCreditCardRepaymentUseCaseInput, SendCreditCardRepaymentUseCaseOkOutput, SendCreditCardRepaymentUseCaseErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: SendCreditCardRepaymentUseCaseInput) throws -> UseCaseResponse<SendCreditCardRepaymentUseCaseOkOutput, SendCreditCardRepaymentUseCaseErrorOutput> {
        let plManagersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        let manager = plManagersProvider.getCreditCardRepaymentManager()
        let form = requestValues.form
        
        guard let account = form.account else {
            return .error(SendCreditCardRepaymentUseCaseErrorOutput("Account not set"))
        }
        
        guard let creditCard = form.creditCard else {
            return .error(SendCreditCardRepaymentUseCaseErrorOutput("Credit Card not set"))
        }
        
        guard let amount = form.amount,
              let amountValue = amount.dto.value,
              let currencyValue = amount.dto.currency?.currencyType.rawValue
        else {
            return .error(SendCreditCardRepaymentUseCaseErrorOutput("Amount not set"))
        }
        
        let debitAmountData = AcceptDomesticTransactionParameters.AmountData(
            amount: amountValue,
            currency: currencyValue
        )
        let debitAccountData = AcceptDomesticTransactionParameters.DebitAccountData(
            accountType: account.accountType,
            accountSequenceNumber: account.sequenceNumber,
            accountNo: account.number
        )
        let creditAccountData = AcceptDomesticTransactionParameters.CreditAccountData(
            accountType: creditCard.accountType,
            accountSequenceNumber: creditCard.sequenceNumber,
            accountNo: creditCard.relatedAccount.number
        )
        let signData = AcceptDomesticTransactionParameters.SignData(securityLevel: 1)
        
        let repaymentParameters = AcceptDomesticTransactionParameters(
            title: localized("pl_creditCard_text_creditCardRepayTransName"),
            type: .OWN_TRANSACTION,
            transferType: .INTERNAL,
            signData: signData,
            valueDate: form.date.toString(format: "yyyy-MM-dd"),
            debitAmountData: debitAmountData,
            debitAccountData: debitAccountData,
            creditAccountData: creditAccountData,
            creditAmountData: debitAmountData
        )
        
        let result = try manager.sendRepayment(repaymentParameters)
        
        switch result {
        case .success(_):
            let summary = CreditCardRepaymentSummary(
                creditCard: creditCard,
                account: account,
                amount: amount,
                date: form.date,
                transferType: localized("pl_creditCard_label_creditCardRepay"))
            let response = SendCreditCardRepaymentUseCaseOkOutput(summary: summary)
            return .ok(response)
            
        case .failure(_):
            return .error(.init("Fail sending confirmation of credit card repayment"))
        }
        
    }
}

extension SendCreditCardRepaymentUseCase: SendCreditCardRepaymentProtocol {}

struct SendCreditCardRepaymentUseCaseInput {
    let form: CreditCardRepaymentForm
}

struct SendCreditCardRepaymentUseCaseOkOutput {
    let summary: CreditCardRepaymentSummary
}

final class SendCreditCardRepaymentUseCaseErrorOutput: StringErrorOutput { }

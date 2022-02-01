import Foundation
import CoreFoundationLib
import CoreFoundationLib

final class GetCreditCardRepaymentAmountOptionsUseCase: UseCase<GetCreditCardRepaymentAmountOptionsUseCaseInput, GetCreditCardRepaymentAmountOptionsUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: GetCreditCardRepaymentAmountOptionsUseCaseInput) throws -> UseCaseResponse<GetCreditCardRepaymentAmountOptionsUseCaseOkOutput, StringErrorOutput> {
        let creditCard = requestValues.creditCard
        
        let options = [
            CreditCardRepaymentAmountOption(type: .minimal, amount: creditCard.minimalPaymentAmount),
            CreditCardRepaymentAmountOption(type: .complete, amount: creditCard.totalPaymentAmount),
            CreditCardRepaymentAmountOption(type: .other, amount: nil)
        ]
        
        let response = GetCreditCardRepaymentAmountOptionsUseCaseOkOutput(options: options)
        return .ok(response)
    }
}

struct GetCreditCardRepaymentAmountOptionsUseCaseInput {
    var creditCard: CCRCardEntity
}

struct GetCreditCardRepaymentAmountOptionsUseCaseOkOutput {
    let options: [CreditCardRepaymentAmountOption]
}

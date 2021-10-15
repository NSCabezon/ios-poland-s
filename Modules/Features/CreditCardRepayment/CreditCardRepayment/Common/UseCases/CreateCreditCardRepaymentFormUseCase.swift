import Foundation
import DomainCommon
import Commons
import Models
import SANLegacyLibrary
import SANPLLibrary

protocol CreateCreditCardRepaymentFormUseCaseProtocol: UseCase<CreateCreditCardRepaymentFormUseCaseOkInput, CreateCreditCardRepaymentFormUseCaseOkOutput, StringErrorOutput> { }

final class CreateCreditCardRepaymentFormUseCase: UseCase<CreateCreditCardRepaymentFormUseCaseOkInput, CreateCreditCardRepaymentFormUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: CreateCreditCardRepaymentFormUseCaseOkInput) throws -> UseCaseResponse<CreateCreditCardRepaymentFormUseCaseOkOutput, StringErrorOutput> {
        let plManagersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    
        let manager = plManagersProvider.getCreditCardRepaymentManager()
        let cardsResult = try manager.getCards()
        let accountsResult = try manager.getAccountsForDebit()
        
        let accountsDTOs: [CCRAccountDTO]
        let cardsDTOs: [CCRCardDTO]
        switch (cardsResult, accountsResult) {
        case (.success(let cards), .success(let accounts)):
            cardsDTOs = cards
            accountsDTOs = accounts
        default:
            return .error(.init(CreateCreditCardRepaymentFormError.fetchingTrouble.rawValue))
        }
        
        if cardsDTOs.isEmpty {
            return .error(.init(CreateCreditCardRepaymentFormError.noCards.rawValue))
        }
        
        let card = makeCard(from: cardsDTOs, accountNumber: requestValues.accountNumber?.number)
        let steps = makeSteps(from: card)
        
        let accountsForRepayment = accountsDTOs
            .filter { $0.type == .PERSONAL || $0.type == .SAVINGS }
            .compactMap(CCRAccountEntity.mapAccountFromDTO)
        
        if accountsForRepayment.isEmpty {
            return .error(.init(CreateCreditCardRepaymentFormError.noAccounts.rawValue))
        }
        
        let account: CCRAccountEntity = accountsForRepayment
            .first(where: { $0.defaultForPayments }) ?? accountsForRepayment.first!
        let accountSelectionPossible: Bool = accountsForRepayment.count > 1
        let currency = Currency.create(account.currencyCode)
        let amount = card?.minimalPaymentAmount
            
        let form = CreditCardRepaymentForm(
            creditCard: card,
            account: account,
            repaymentType: .minimal,
            amount: amount,
            date: Date()
        )
        
        let response = CreateCreditCardRepaymentFormUseCaseOkOutput(
            form: form,
            steps: steps,
            accountSelectionPossible: accountSelectionPossible,
            currency: currency
        )
        return .ok(response)
    }
}

private extension CreateCreditCardRepaymentFormUseCase {
    private func makeCard(from cardsDTOs: [CCRCardDTO], accountNumber: String?) -> CCRCardEntity? {
        let cards = cardsDTOs.compactMap(CCRCardEntity.mapCardFromDTO(_:))
        
        switch (cards.count, accountNumber) {
        case (_, .some(let number)):
            return cards.first(where: {$0.relatedAccount.number == number})
        case (1, _):
            return cards.first
        default:
            return nil
        }
    }
    
    private func makeSteps(from card: CCRCardEntity?) -> [CreditCardRepaymentStep] {
        if card != nil {
            return [.form, .confirm]
        } else {
            return [.chooseCard, .form, .confirm]
        }
    }
}

extension CreateCreditCardRepaymentFormUseCase: CreateCreditCardRepaymentFormUseCaseProtocol {}

struct CreateCreditCardRepaymentFormUseCaseOkInput {
    let accountNumber: CreditCardAccountNumber?
}

struct CreateCreditCardRepaymentFormUseCaseOkOutput {
    let form: CreditCardRepaymentForm
    let steps: [CreditCardRepaymentStep]
    let accountSelectionPossible: Bool
    let currency: Currency
}

enum CreateCreditCardRepaymentFormError: String {
    case fetchingTrouble
    case noCards
    case noAccounts
}

import Foundation
import CoreFoundationLib
import Commons
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
        
        let card = makeCard(from: cardsDTOs, creditCardEntity: requestValues.creditCardEntity)
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
    private func makeCard(from cardsDTOs: [CCRCardDTO], creditCardEntity: CardEntity?) -> CCRCardEntity? {
        let card: CCRCardDTO?
        switch (cardsDTOs.count, creditCardEntity) {
        case (_, .some(let cardEntity)):
            card = cardsDTOs.first(where: {$0.isEqualTo(cardEntity.dto) })
        case (1, _):
            card = cardsDTOs.first
        default:
            card = nil
        }
        
        guard let card = card else { return nil }
        return CCRCardEntity.mapCardFromDTO(card)
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
    let creditCardEntity: CardEntity?
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

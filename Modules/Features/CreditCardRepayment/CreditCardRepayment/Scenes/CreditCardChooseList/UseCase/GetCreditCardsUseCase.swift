import Foundation
import DomainCommon
import Commons
import Models
import SANPLLibrary

final class GetCreditCardsUseCase: UseCase<Void, GetCreditCardsUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetCreditCardsUseCaseOkOutput, StringErrorOutput> {
        let plManagersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        
        let manager = plManagersProvider.getCreditCardRepaymentManager()
        let cardsResult = try manager.getCards()
        
        let cards: [CCRCardEntity]
        switch cardsResult {
        case let .success(cardsDTOs):
            cards = cardsDTOs.compactMap(CCRCardEntity.mapCardFromDTO)
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
        
        let response = GetCreditCardsUseCaseOkOutput(cards: cards)
        return .ok(response)
    }
}

struct GetCreditCardsUseCaseOkOutput {
    let cards: [CCRCardEntity]
}

import Foundation
import CoreDomain
import OpenCombine
import CoreFoundationLib
import SANLegacyLibrary

public protocol PLCardManagerAdapterProtocol {
    func getCardDetail(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<SANLegacyLibrary.CardDetailDTO>
    func changeCardAlias(cardDTO: SANLegacyLibrary.CardDTO, newAlias: String) throws -> BSANResponse<Void>
}

public final class CardReactiveDataRepository {
    private let bsanDataProvider: BSANDataProvider
    private let cardManager: PLCardManagerAdapterProtocol
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, cardManager: PLCardManagerAdapterProtocol) {
        self.bsanDataProvider = bsanDataProvider
        self.cardManager = cardManager
    }
}

extension CardReactiveDataRepository: CardRepository {
    public func loadTransactions(card: CardRepresentable, page: PaginationRepresentable?, filter: CardTransactionFiltersRepresentable?) -> AnyPublisher<CardTransactionsListRepresentable, Error> {
        Fail(error: NSError(description: "unknown")).eraseToAnyPublisher()
    }
    
    public func loadCardDetail(card: CardRepresentable) -> AnyPublisher<CardDetailRepresentable, Error> {
        guard let cardDTO = card as? SANLegacyLibrary.CardDTO else {
            return Empty().eraseToAnyPublisher()
        }
        return Future<CoreDomain.CardDetailRepresentable, Error> { promise in
            Async(queue: .global(qos: .userInitiated)) {
                do {
                    let result = try self.getCardDetail(forCard: cardDTO)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func changeAliasCard(card: CardRepresentable, newAlias: String) -> AnyPublisher<Void, Error> {
        guard let cardDTO = card as? SANLegacyLibrary.CardDTO else {
            return Empty().eraseToAnyPublisher()
        }
        return Future { promise in
            Async(queue: .global(qos: .userInitiated)) {
                do {
                    let _ = try self.changeAlias(forCard: cardDTO, newAlias: newAlias)
                    promise(.success(()))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func loadCardTransactionLocationsList(card: CardRepresentable) -> AnyPublisher<[CardMovementLocationRepresentable], Never> {
        return Just([]).eraseToAnyPublisher()
    }
    
    public func loadCardTransactionLocationsListByDate(card: CardRepresentable, startDate: Date, endDate: Date) -> AnyPublisher<[CardMovementLocationRepresentable], Never> {
        return Just([]).eraseToAnyPublisher()
    }
}

fileprivate extension CardReactiveDataRepository {
    
    func getCardDetail(forCard card: SANLegacyLibrary.CardDTO) throws -> CardDetailRepresentable {
        let response = try cardManager.getCardDetail(cardDTO: card)
        guard let result = try response.getResponseData() else {
            throw SomeError(errorDescription: try response.getErrorMessage())
        }
        return result
    }
    
    func changeAlias(forCard card: SANLegacyLibrary.CardDTO, newAlias: String) throws -> Void {
        let response = try cardManager.changeCardAlias(cardDTO: card, newAlias: newAlias)
        if !response.isSuccess() {
            throw SomeError(errorDescription: try response.getErrorMessage())
        }
    }
}

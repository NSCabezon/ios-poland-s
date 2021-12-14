import Foundation

public protocol PLCreditCardRepaymentManagerProtocol {
    func getAccountsForDebit() throws -> Result<[CCRAccountDTO], NetworkProviderError>
    func getAccountsForCredit() throws -> Result<[CCRAccountDTO], NetworkProviderError>
    func getCards() throws -> Result<[CCRCardDTO], NetworkProviderError>
    func sendRepayment(_ parameters: AcceptDomesticTransactionParameters) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError>
}

public final class PLCreditCardRepaymentManager {
    private let creditCardRepaymentDataSource: CreditCardRepaymentDataSourceProtocol
    private let cardDetailDataSource: CardDetailDataSourceProtocol
    private let globalPositionDataSource: GlobalPositionDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.creditCardRepaymentDataSource = CreditCardRepaymentDataSource(
            networkProvider: networkProvider,
            dataProvider: bsanDataProvider
        )
        self.cardDetailDataSource = CardDetailDataSource(
            networkProvider: networkProvider,
            dataProvider: bsanDataProvider
        )
        self.globalPositionDataSource = GlobalPositionDataSource(
            networkProvider: networkProvider,
            dataProvider: bsanDataProvider
        )
        self.bsanDataProvider = bsanDataProvider
    }
}

extension PLCreditCardRepaymentManager: PLCreditCardRepaymentManagerProtocol {
    
    public func getAccountsForDebit() throws -> Result<[CCRAccountDTO], NetworkProviderError> {
        if let cachedInfo = bsanDataProvider.getCreditCardRepaymentInfo(), !cachedInfo.accountsForDebit.isEmpty {
            return .success(cachedInfo.accountsForDebit)
        }
        
        let result = try creditCardRepaymentDataSource.getAccountsForDebit()
        switch result {
        case .success(let accounts):
            let filteredAccounts = accounts.filter { $0.accountDetails != nil }
            bsanDataProvider.store(creditCardRepaymentDebitAccounts: filteredAccounts)
            return .success(filteredAccounts)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func getAccountsForCredit() throws -> Result<[CCRAccountDTO], NetworkProviderError> {
        if let cachedInfo = bsanDataProvider.getCreditCardRepaymentInfo(), !cachedInfo.accountsForCredit.isEmpty {
            return .success(cachedInfo.accountsForCredit)
        }
        
        let result = try creditCardRepaymentDataSource.getAccountsForCredit()
        switch result {
        case .success(let accounts):
            bsanDataProvider.store(creditCardRepaymentCreditAccounts: accounts)
            return .success(accounts)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func getCards() throws -> Result<[CCRCardDTO], NetworkProviderError> {
        if let cachedInfo = bsanDataProvider.getCreditCardRepaymentInfo(), !cachedInfo.cards.isEmpty {
            return .success(cachedInfo.cards)
        }
        
        let cards: [CardDTO]
        if let sessionData = try? self.bsanDataProvider.getSessionData(),
           let cardsDTOs = sessionData.globalPositionDTO?.cards, !cardsDTOs.isEmpty {
            cards = cardsDTOs // First we get cards from global position cache
        } else if case let .success(globalPosition) = try globalPositionDataSource.getGlobalPosition(GlobalPositionParameters(filterBy: .cards)) {
            cards = globalPosition.cards ?? [] // But if there are none, we fetch them by ourself
        } else {
            return .failure(NetworkProviderError.other)
        }
        
        let accounts: [CCRAccountDTO]
        if case let .success(accountsDTOs) = try getAccountsForCredit() {
            accounts = accountsDTOs
        } else {
            return .failure(NetworkProviderError.other)
        }
        
        // Conditions have been taken from this story https://godzilla.centrala.bzwbk:9998/browse/MOBILE-8148
        let ccrCards = try cards
            .filter { $0.type == "CREDIT" }
            .filter { $0.generalStatus != "CANCELLED" && $0.generalStatus != "INACTIVE" }
            .compactMap { card -> CCRCardDTO? in
                guard let account = accounts.first(where: { card.relatedAccount == $0.number }) else { return nil }
                let creditCardAccountDetails: CreditCardDetailsDTO? = try {
                    if let panIdentifier = card.panIdentifier,
                       case let .success(cardDetailDTO) = try getCardDetail(cardId: panIdentifier) {
                        return cardDetailDTO.creditCardAccountDetails
                    } else {
                        return nil
                    }
                }()
                return CCRCardDTO.mapFromCardDTO(card, account: account, creditCardAccountDetails: creditCardAccountDetails)
            }
        
        bsanDataProvider.store(creditCardRepaymentCards: ccrCards)
        return .success(ccrCards)
    }
    
    func getCardDetail(cardId: String) throws -> Result<CardDetailDTO, NetworkProviderError> {
        let parameters: CardDetailParameters = CardDetailParameters(virtualPan: cardId)
        let result = try self.cardDetailDataSource.getCardDetail(parameters)
        return result
    }
    
    public func sendRepayment(_ parameters: AcceptDomesticTransactionParameters) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        let result = try creditCardRepaymentDataSource.sendRepayment(parameters)
        return result
    }
}

//
//  PLCardsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import CoreDomain
import SANPLLibrary

final class PLCardsManagerAdapter {
    private let cardsManager: PLCardsManagerProtocol
    private let bsanDataProvider: BSANDataProvider
    private let globalPositionManager: PLGlobalPositionManagerProtocol
    private let cardTransactionsManager: PLCardTransactionsManagerProtocol
    private let cardOperativesManager: PLCardOperativesManagerProtocol

    public init(cardsManager: PLCardsManagerProtocol, bsanDataProvider: BSANDataProvider, globalPositionManager: PLGlobalPositionManagerProtocol, cardTransactionsManager: PLCardTransactionsManagerProtocol, cardOperativesManager: PLCardOperativesManagerProtocol) {
        self.cardsManager = cardsManager
        self.bsanDataProvider = bsanDataProvider
        self.globalPositionManager = globalPositionManager
        self.cardTransactionsManager = cardTransactionsManager
        self.cardOperativesManager = cardOperativesManager
    }
}

extension PLCardsManagerAdapter: BSANCardsManager {
    func getAmortizationEasyPay(cardDTO: SANLegacyLibrary.CardDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO, feeDataDTO: FeeDataDTO, numFeesSelected: String, balanceCode: Int, movementIndex: Int) throws -> BSANResponse<EasyPayAmortizationDTO> {
        return BSANErrorResponse(nil)
    }

    func getFractionablePurchaseDetail(input: FractionablePurchaseDetailParameters) throws -> BSANResponse<FinanceableMovementDetailDTO> {
        return BSANErrorResponse(nil)
    }

    func getCardTransactionLocation(card: SANLegacyLibrary.CardDTO, transaction: SANLegacyLibrary.CardTransactionDTO, transactionDetail: CardTransactionDetailDTO) throws -> BSANResponse<CardMovementLocationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardTransactionLocationsList(card: SANLegacyLibrary.CardDTO) throws -> BSANResponse<CardMovementLocationListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardTransactionLocationsListByDate(card: SANLegacyLibrary.CardDTO, startDate: Date, endDate: Date) throws -> BSANResponse<CardMovementLocationListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAllCards() throws -> BSANResponse<[SANLegacyLibrary.CardDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getAllCardTransactions(cardDTO: SANLegacyLibrary.CardDTO,
                                searchTerm: String?,
                                dateFilter: DateFilter?,
                                fromAmount: Decimal?,
                                toAmount: Decimal?,
                                movementType: String?,
                                cardOperationType: String?) throws -> BSANResponse<CardTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardsDataMap() throws -> BSANResponse<[String : CardDataDTO]> {
        guard let cardsDTO = cardsManager.getCards() else  {
            return BSANOkResponse([:])
        }
        let cardsDataMap = cardsDTO.reduce([String: CardDataDTO](), { result, card in
            var new = result
            let cardData = CardDataDTOAdapter.adaptPLCardToCard(card, customer: nil)
            guard let cardPAN = cardData.PAN else { return result }
            new[cardPAN] = cardData
            return new
        })
        return BSANOkResponse(cardsDataMap)
    }
    
    func getPrepaidsCardsDataMap() throws -> BSANResponse<[String : PrepaidCardDataDTO]> {
        return BSANOkResponse([:])
    }
    
    func getCardsDetailMap() throws -> BSANResponse<[String : SANLegacyLibrary.CardDetailDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getCardsWithDetailMap() throws -> BSANResponse<[String : SANLegacyLibrary.CardDetailDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getCardsBalancesMap() throws -> BSANResponse<[String : CardBalanceDTO]> {
        guard let cardsDTO = cardsManager.getCards() else  {
            return BSANOkResponse([:])
        }
        let cardsBalanceMap = cardsDTO.reduce([String: CardBalanceDTO](), { result, card in
            var new = result
            let cardBalance = CardBalanceDTOAdapter.adaptPLBalance(card)
            guard let cardPAN = card.maskedPan else { return result }
            new[cardPAN] = cardBalance
            return new
        })
        return BSANOkResponse(cardsBalanceMap)
    }
    
    func getTemporallyInactiveCardsMap() throws -> BSANResponse<[String : InactiveCardDTO]> {
        guard let cardsDTO = self.cardsManager.getCards() else  {
            return BSANOkResponse([:])
        }
        let temporallyOffCardsDTO = self.filterTemporallyOffCards(cardsDTO)
        let temporallyOffCardsDTOMap = self.createListOfInactiveCards(temporallyOffCardsDTO)
        return BSANOkResponse(temporallyOffCardsDTOMap)
    }
    
    func getInactiveCardsMap() throws -> BSANResponse<[String : InactiveCardDTO]> {
        guard let cardsDTO = self.cardsManager.getCards() else  {
            return BSANOkResponse([:])
        }
        let inactiveCardsDTO = self.filterInactiveCards(cardsDTO)
        let inactiveCardsDataMap = self.createListOfInactiveCards(inactiveCardsDTO)
        return BSANOkResponse(inactiveCardsDataMap)
    }
    
    func getCardData(_ pan: String) throws -> BSANResponse<CardDataDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadAllCardsData() throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getTemporallyOffCard(pan: String) throws -> BSANResponse<InactiveCardDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getInactiveCard(pan: String) throws -> BSANResponse<InactiveCardDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadCardDetail(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }

    func getCardDetail(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<SANLegacyLibrary.CardDetailDTO> {
        guard let cards = self.bsanDataProvider.getGlobalPosition()?.cards else { return BSANErrorResponse(nil) }
        let card = cards.first { $0.virtualPan == cardDTO.contract?.contractNumber }
        guard let cardId = card?.virtualPan else { return BSANErrorResponse(nil) }
        let result = try cardsManager.getCardDetail(cardId: cardId)
        switch result {
        case .success(let cardDetail):
            if cardDTO.cardTypeDescription?.lowercased() == "credit" {
                let adaptedCardDetail = CardDetailDTOAdapter.adaptPLCreditCardToCardDetail(cardDetail)
                return BSANOkResponse(adaptedCardDetail)
            } else {
                let adaptedCardDetail = CardDetailDTOAdapter.adaptPLDebitCardToCardDetail(cardDetail)
                return BSANOkResponse(adaptedCardDetail)
            }
        case .failure( _):
            return BSANErrorResponse(nil)
        }
    }
    
    func getCardBalance(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<CardBalanceDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPayOff(cardDTO: SANLegacyLibrary.CardDTO, cardDetailDTO: SANLegacyLibrary.CardDetailDTO, amountDTO: AmountDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loadPrepaidCardData(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getPrepaidCardData(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<PrepaidCardDataDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateLoadPrepaidCard(cardDTO: SANLegacyLibrary.CardDTO, amountDTO: AmountDTO, accountDTO: SANLegacyLibrary.AccountDTO, prepaidCardDataDTO: PrepaidCardDataDTO) throws -> BSANResponse<ValidateLoadPrepaidCardDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmOTPLoadPrepaidCard(cardDTO: SANLegacyLibrary.CardDTO, amountDTO: AmountDTO, accountDTO: SANLegacyLibrary.AccountDTO, prepaidCardDataDTO: PrepaidCardDataDTO, validateLoadPrepaidCardDTO: ValidateLoadPrepaidCardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateUnloadPrepaidCard(cardDTO: SANLegacyLibrary.CardDTO, amountDTO: AmountDTO, accountDTO: SANLegacyLibrary.AccountDTO, prepaidCardDataDTO: PrepaidCardDataDTO) throws -> BSANResponse<ValidateLoadPrepaidCardDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmOTPUnloadPrepaidCard(cardDTO: SANLegacyLibrary.CardDTO, amountDTO: AmountDTO, accountDTO: SANLegacyLibrary.AccountDTO, prepaidCardDataDTO: PrepaidCardDataDTO, validateLoadPrepaidCardDTO: ValidateLoadPrepaidCardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateOTPPrepaidCard(cardDTO: SANLegacyLibrary.CardDTO, signatureDTO: SignatureDTO, validateLoadPrepaidCardDTO: ValidateLoadPrepaidCardDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardDetailToken(cardDTO: SANLegacyLibrary.CardDTO, cardTokenType: CardTokenType) throws -> BSANResponse<CardDetailTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAllCardTransactions(cardDTO: SANLegacyLibrary.CardDTO, pagination: PaginationDTO?, searchTerm: String?, dateFilter: DateFilter?, fromAmount: Decimal?, toAmount: Decimal?, movementType: String?, cardOperationType: String?) throws -> BSANResponse<CardTransactionsListDTO> {
        return self.loadCardTransactions(cardDTO: cardDTO, pagination: pagination, searchTerm: searchTerm, dateFilter: dateFilter, fromAmount: fromAmount, toAmount: toAmount, movementType: movementType, cardOperationType: cardOperationType)
    }

    func getCardTransactions(cardDTO: SANLegacyLibrary.CardDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<CardTransactionsListDTO> {
        return self.loadCardTransactions(cardDTO: cardDTO, pagination: pagination, dateFilter: dateFilter)
    }

    func getCardTransactions(cardDTO: SANLegacyLibrary.CardDTO, pagination: PaginationDTO?, dateFilter: DateFilter?, cached: Bool) throws -> BSANResponse<CardTransactionsListDTO> {
        return self.loadCardTransactions(cardDTO: cardDTO, pagination: pagination, dateFilter: dateFilter)
    }
    
    func getCardTransactionDetail(cardDTO: SANLegacyLibrary.CardDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO) throws -> BSANResponse<CardTransactionDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadInactiveCards(inactiveCardType: InactiveCardType) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func blockCard(cardDTO: SANLegacyLibrary.CardDTO, blockText: String, cardBlockType: CardBlockType) throws -> BSANResponse<BlockCardDTO> {
        return BSANErrorResponse(nil)
    }

    func onOffCard(cardDTO: SANLegacyLibrary.CardDTO, option: CardBlockType) throws -> BSANResponse<Void> {
        guard let cards = self.bsanDataProvider.getGlobalPosition()?.cards,
              let card = cards.first(where: { $0.virtualPan == cardDTO.contract?.contractNumber }),
              let cardId = card.virtualPan else {
            return BSANErrorResponse(nil)
        }

        switch option {
        case .turnOn:
            if case .success = try cardOperativesManager.unblockCard(cardId: cardId) {
                return BSANOkResponse(nil)
            }
        case .turnOff:
            if case .success = try cardOperativesManager.blockCard(cardId: cardId) {
                return BSANOkResponse(nil)
            }
        default:
            return BSANErrorResponse(nil)
        }

        return BSANErrorResponse(nil)
    }
    
    func confirmBlockCard(cardDTO: SANLegacyLibrary.CardDTO, signatureDTO: SignatureDTO, blockText: String, cardBlockType: CardBlockType) throws -> BSANResponse<BlockCardConfirmDTO> {
        return BSANErrorResponse(nil)
    }
    
    func activateCard(cardDTO: SANLegacyLibrary.CardDTO, expirationDate: Date) throws -> BSANResponse<ActivateCardDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmActivateCard(cardDTO: SANLegacyLibrary.CardDTO, expirationDate: Date, signatureDTO: SignatureDTO) throws -> BSANResponse<String> {
        return BSANErrorResponse(nil)
    }
    
    func prepareDirectMoney(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<DirectMoneyDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateDirectMoney(cardDTO: SANLegacyLibrary.CardDTO, amountValidatedDTO: AmountDTO) throws -> BSANResponse<DirectMoneyValidatedDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmDirectMoney(cardDTO: SANLegacyLibrary.CardDTO, amountValidatedDTO: AmountDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loadCardSuperSpeed(pagination: PaginationDTO?) throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    func loadCardSuperSpeed(pagination: PaginationDTO?, isNegativeCreditBalanceEnabled: Bool) throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    func changeCardAlias(cardDTO: SANLegacyLibrary.CardDTO, newAlias: String) throws -> BSANResponse<Void> {
        return try self.changeAlias(cardDTO: cardDTO, newAlias: newAlias)
    }
    
    func validateCVVOTP(cardDTO: SANLegacyLibrary.CardDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateCVV(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<SCARepresentable> {
        return BSANErrorResponse(nil)
    }
    
    func confirmCVV(cardDTO: SANLegacyLibrary.CardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<NumberCipherDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validatePIN(cardDTO: SANLegacyLibrary.CardDTO, cardDetailTokenDTO: CardDetailTokenDTO) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validatePINOTP(cardDTO: SANLegacyLibrary.CardDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPIN(cardDTO: SANLegacyLibrary.CardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<NumberCipherDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getPayLaterData(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<PayLaterDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPayLaterData(cardDTO: SANLegacyLibrary.CardDTO, payLaterDTO: PayLaterDTO, amountDTO: AmountDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getTransactionDetailEasyPay(cardDTO: SANLegacyLibrary.CardDTO, cardDetailDTO: SANLegacyLibrary.CardDetailDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO, cardTransactionDetailDTO: CardTransactionDetailDTO, easyPayContractTransactionDTO: EasyPayContractTransactionDTO) throws -> BSANResponse<EasyPayDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAllTransactionsEasyPayContract(cardDTO: SANLegacyLibrary.CardDTO, dateFilter: DateFilter?) throws -> BSANResponse<EasyPayContractTransactionListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getTransactionsEasyPayContract(cardDTO: SANLegacyLibrary.CardDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<EasyPayContractTransactionListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getFeesEasyPay(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<FeeDataDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAmortizationEasyPay(cardDTO: SANLegacyLibrary.CardDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO, feeDataDTO: FeeDataDTO, numFeesSelected: String) throws -> BSANResponse<EasyPayAmortizationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmationEasyPay(cardDTO: SANLegacyLibrary.CardDTO, cardDetailDTO: SANLegacyLibrary.CardDetailDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO, cardTransactionDetailDTO: CardTransactionDetailDTO, easyPayDTO: EasyPayDTO, easyPayAmortizationDTO: EasyPayAmortizationDTO, easyPayContractTransactionDTO: EasyPayContractTransactionDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateModifyDebitCardLimitOTP(cardDTO: SANLegacyLibrary.CardDTO, signatureWithToken: SignatureWithTokenDTO, debitLimitDailyAmount: AmountDTO, atmLimitDailyAmount: AmountDTO, creditLimitDailyAmount: AmountDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateModifyCreditCardLimitOTP(cardDTO: SANLegacyLibrary.CardDTO, signatureWithToken: SignatureWithTokenDTO, atmLimitDailyAmount: AmountDTO, creditLimitDailyAmount: AmountDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmModifyDebitCardLimitOTP(cardDTO: SANLegacyLibrary.CardDTO, otpCode: String, otpValidationDTO: OTPValidationDTO, debitLimitDailyAmount: AmountDTO, atmLimitDailyAmount: AmountDTO, cardSuperSpeedDTO: CardSuperSpeedDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmModifyCreditCardLimitOTP(cardDTO: SANLegacyLibrary.CardDTO, otpCode: String, otpValidationDTO: OTPValidationDTO, atmLimitDailyAmount: AmountDTO, cardSuperSpeedDTO: CardSuperSpeedDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getCardPendingTransactions(cardDTO: SANLegacyLibrary.CardDTO, pagination: PaginationDTO?) throws -> BSANResponse<CardPendingTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func checkCardExtractPdf(cardDTO: SANLegacyLibrary.CardDTO, dateFilter: DateFilter, isPCAS: Bool) throws -> BSANResponse<DocumentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func checkCardExtractPdf(cardDTO: SANLegacyLibrary.CardDTO, dateFilter: DateFilter) throws -> BSANResponse<DocumentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getPaymentChange(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<ChangePaymentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPaymentChange(cardDTO: SANLegacyLibrary.CardDTO, input: ChangePaymentMethodConfirmationInput) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loadApplePayStatus(for addedPasses: [String]) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getApplePayStatus(for card: SANLegacyLibrary.CardDTO, expirationDate: DateModel) throws -> BSANResponse<CardApplePayStatusDTO> {
        return BSANOkResponse(nil)
    }
    
    func validateApplePay(card: SANLegacyLibrary.CardDTO, signature: SignatureWithTokenDTO) throws -> BSANResponse<ApplePayValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmApplePay(card: SANLegacyLibrary.CardDTO, cardDetail: SANLegacyLibrary.CardDetailDTO, otpValidation: OTPValidationDTO, otpCode: String, encryptionScheme: String, publicCertificates: [Data], nonce: Data, nonceSignature: Data) throws -> BSANResponse<ApplePayConfirmationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardApplePayStatus() throws -> BSANResponse<[String : CardApplePayStatusDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getCardSettlementDetail(card: SANLegacyLibrary.CardDTO, date: Date) throws -> BSANResponse<CardSettlementDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardSettlementListMovements(card: SANLegacyLibrary.CardDTO, extractNumber: Int) throws -> BSANResponse<[CardSettlementMovementDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getCardSettlementListMovementsByContract(card: SANLegacyLibrary.CardDTO, extractNumber: Int) throws -> BSANResponse<[CardSettlementMovementWithPANDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func confirmationEasyPay(input: BuyFeesParameters, card: SANLegacyLibrary.CardDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getEasyPayFees(input: BuyFeesParameters, card: SANLegacyLibrary.CardDTO) throws -> BSANResponse<FeesInfoDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getEasyPayFinanceableList(input: FinanceableListParameters) throws -> BSANResponse<FinanceableMovementsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardSubscriptionsList(input: SubscriptionsListParameters) throws -> BSANResponse<CardSubscriptionsListDTO> {
        return BSANErrorResponse(nil)
    }

    func getCardSubscriptionsHistorical(input: SubscriptionsHistoricalInputParams) throws -> BSANResponse<CardSubscriptionsHistoricalListDTO> {
        return BSANErrorResponse(nil)
    }

    func getCardSubscriptionsGraphData(input: SubscriptionsGraphDataInputParams) throws -> BSANResponse<CardSubscriptionsGraphDataDTO> {
        return BSANErrorResponse(nil)
    }
}

//MARK: - Private Methods
private extension PLCardsManagerAdapter {
    func filterInactiveCards(_ cards: [SANPLLibrary.CardDTO]) -> [SANPLLibrary.CardDTO] {
        return cards.filter { $0.generalStatus == "INACTIVE" }
    }

    func filterTemporallyOffCards(_ cards: [SANPLLibrary.CardDTO]) -> [SANPLLibrary.CardDTO] {
        return cards.filter { $0.generalStatus != "ACTIVE" }
    }

    func createListOfInactiveCards(_ inactiveCardsDTO: [SANPLLibrary.CardDTO]) -> [String : InactiveCardDTO] {
        let cardsDataMap = inactiveCardsDTO.reduce([String: InactiveCardDTO](), { result, card in
            let inactiveCard = CardDTOAdapter.adaptPLCardToInactiveCard(card)
            guard let cardPAN = inactiveCard.PAN else { return result }
            var newResult = result
            newResult[cardPAN] = inactiveCard
            return newResult
        })
        return cardsDataMap
    }

    func getCardFromDTO(_ card: SANLegacyLibrary.CardDTO) -> SANPLLibrary.CardDTO? {
        let cards = self.bsanDataProvider.getGlobalPosition()?.cards
        return cards?.first { $0.virtualPan == card.contract?.contractNumber }
    }
    
    private func loadCardTransactions(cardDTO: SANLegacyLibrary.CardDTO, pagination: PaginationDTO?, searchTerm: String? = nil, dateFilter: DateFilter?, fromAmount: Decimal? = nil, toAmount: Decimal? = nil, movementType: String? = nil, cardOperationType: String? = nil) -> BSANResponse<CardTransactionsListDTO> {
        let cardPagination = TransactionsLinksDTO(next: pagination?.repositionXML ?? "", previous: pagination?.accountAmountXML ?? "")
        
        guard let cardId = cardDTO.contract?.contractNumber else { return BSANErrorResponse(nil) }
        
        let cardKey = getCardKeyWithFilters(cardId: cardId,
                                            searchTerm: searchTerm,
                                            startDate: dateFilter?.fromDateModel?.stringReverseWithDashSeparator,
                                            endDate: dateFilter?.toDateModel?.stringReverseWithDashSeparator,
                                            fromAmount: fromAmount,
                                            toAmount: toAmount,
                                            movementType: movementType,
                                            cardOperationType: cardOperationType)
        
        if pagination == nil {
            let resetCardPagination = TransactionsLinksDTO(next: "", previous:  "")
            self.bsanDataProvider.storeCardPagination(cardKey, resetCardPagination)
        }
        
        let transactions = cardTransactionsManager.loadCardTransactions(cardId: cardId,
                                                                              pagination: cardPagination,
                                                                              searchTerm: searchTerm,
                                                                              startDate: dateFilter?.fromDateModel?.stringReverseWithDashSeparator,
                                                                              endDate: dateFilter?.toDateModel?.stringReverseWithDashSeparator,
                                                                              fromAmount: fromAmount,
                                                                              toAmount: toAmount,
                                                                              movementType: movementType,
                                                                              cardOperationType: cardOperationType)
        switch transactions {
        case .success(let plCardTransactions):
            let cardTransactionsAdapter = CardTransactionsDTOAdapter()
            let cardTransactions = cardTransactionsAdapter.adaptPLCardTransactionsToCardTransactionsList(plCardTransactions)
            return BSANOkResponse(cardTransactions)
        case .failure:
            return BSANErrorResponse(nil)
        default:
            return BSANErrorResponse(nil)
        }
    }
    
    private func loadCardTransactions(cardDTO: SANLegacyLibrary.CardDTO, pagination: PaginationDTO?, searchTerm: String? = nil, dateFilter: DateFilter?, fromAmount: Decimal? = nil, toAmount: Decimal? = nil, movementType: String? = nil, cardOperationType: String? = nil, cached: Bool = false) -> BSANResponse<CardTransactionsListDTO> {
        return loadCardTransactions(cardDTO: cardDTO, pagination: pagination, searchTerm: searchTerm, dateFilter: dateFilter, fromAmount: fromAmount, toAmount: toAmount, movementType: movementType, cardOperationType: cardOperationType)
    }
    
    private func changeAlias(cardDTO: SANLegacyLibrary.CardDTO, newAlias: String) throws -> BSANResponse<Void> {
        let result = try? cardTransactionsManager.changeAlias(cardDTO: cardDTO, newAlias: newAlias)
        
        switch result {
        case .success:
            return BSANOkResponse(nil)
        case .failure:
            return BSANErrorResponse(nil)
        default:
            return BSANErrorResponse(nil)
        }
    }
    
    private func getCardKeyWithFilters(cardId: String, searchTerm: String? = nil, startDate: String?, endDate: String?, fromAmount: Decimal?, toAmount: Decimal?, movementType: String?, cardOperationType: String?) -> String {
        var cardKey = cardId
        
        if let searchTerm = searchTerm {
            cardKey = cardKey + "_" + searchTerm
        }
        
        if let startDate = startDate {
            cardKey = cardKey + "_" + startDate
        }
        
        if let endDate = endDate {
            cardKey = cardKey + "_" + endDate
        }
        
        if let fromAmount = fromAmount {
            cardKey = cardKey + "_" + "\(fromAmount)"
        }
        
        if let toAmount = toAmount {
            cardKey = cardKey + "_" + "\(toAmount)"
        }
        
        if let movementType = movementType {
            cardKey = cardKey + "_" + movementType
        }
        
        if let cardOperationType = cardOperationType {
            cardKey = cardKey + "_" + cardOperationType
        }
        
        return cardKey
    }
}

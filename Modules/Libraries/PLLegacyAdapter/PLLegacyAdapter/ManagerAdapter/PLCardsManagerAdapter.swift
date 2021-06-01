//
//  PLCardsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary

final class PLCardsManagerAdapter {
    private let cardsManager: PLCardsManagerProtocol

    public init(cardsManager: PLCardsManagerProtocol) {
        self.cardsManager = cardsManager
    }
}

extension PLCardsManagerAdapter: BSANCardsManager {

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
    
    func getCardsDataMap() throws -> BSANResponse<[String : CardDataDTO]> {
        return BSANOkResponse([:])
    }
    
    func getPrepaidsCardsDataMap() throws -> BSANResponse<[String : PrepaidCardDataDTO]> {
        return BSANOkResponse([:])
    }
    
    func getCardsDetailMap() throws -> BSANResponse<[String : CardDetailDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getCardsWithDetailMap() throws -> BSANResponse<[String : CardDetailDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getCardsBalancesMap() throws -> BSANResponse<[String : CardBalanceDTO]> {
        return BSANOkResponse([:])
    }
    
    func getTemporallyInactiveCardsMap() throws -> BSANResponse<[String : InactiveCardDTO]> {
        return BSANOkResponse([:])
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
    
    func getCardDetail(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<CardDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardBalance(cardDTO: SANLegacyLibrary.CardDTO) throws -> BSANResponse<CardBalanceDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPayOff(cardDTO: SANLegacyLibrary.CardDTO, cardDetailDTO: CardDetailDTO, amountDTO: AmountDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<Void> {
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
    
    func getAllCardTransactions(cardDTO: SANLegacyLibrary.CardDTO, dateFilter: DateFilter?) throws -> BSANResponse<CardTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardTransactions(cardDTO: SANLegacyLibrary.CardDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<CardTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardTransactions(cardDTO: SANLegacyLibrary.CardDTO, pagination: PaginationDTO?, dateFilter: DateFilter?, cached: Bool) throws -> BSANResponse<CardTransactionsListDTO> {
        return BSANErrorResponse(nil)
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
        return BSANErrorResponse(nil)
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
    
    func getTransactionDetailEasyPay(cardDTO: SANLegacyLibrary.CardDTO, cardDetailDTO: CardDetailDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO, cardTransactionDetailDTO: CardTransactionDetailDTO, easyPayContractTransactionDTO: EasyPayContractTransactionDTO) throws -> BSANResponse<EasyPayDTO> {
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
    
    func confirmationEasyPay(cardDTO: SANLegacyLibrary.CardDTO, cardDetailDTO: CardDetailDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO, cardTransactionDetailDTO: CardTransactionDetailDTO, easyPayDTO: EasyPayDTO, easyPayAmortizationDTO: EasyPayAmortizationDTO, easyPayContractTransactionDTO: EasyPayContractTransactionDTO) throws -> BSANResponse<Void> {
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
    
    func confirmApplePay(card: SANLegacyLibrary.CardDTO, cardDetail: CardDetailDTO, otpValidation: OTPValidationDTO, otpCode: String, encryptionScheme: String, publicCertificates: [Data], nonce: Data, nonceSignature: Data) throws -> BSANResponse<ApplePayConfirmationDTO> {
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
}

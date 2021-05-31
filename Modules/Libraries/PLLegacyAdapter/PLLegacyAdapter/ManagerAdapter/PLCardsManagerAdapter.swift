//
//  PLCardsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

final class PLCardsManagerAdapter {}

extension PLCardsManagerAdapter: BSANCardsManager {

    func getCardTransactionLocation(card: CardDTO, transaction: SANLegacyLibrary.CardTransactionDTO, transactionDetail: CardTransactionDetailDTO) throws -> BSANResponse<CardMovementLocationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardTransactionLocationsList(card: CardDTO) throws -> BSANResponse<CardMovementLocationListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardTransactionLocationsListByDate(card: CardDTO, startDate: Date, endDate: Date) throws -> BSANResponse<CardMovementLocationListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAllCards() throws -> BSANResponse<[CardDTO]> {
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
        return BSANOkResponse([:])
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
    
    func loadCardDetail(cardDTO: CardDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getCardDetail(cardDTO: CardDTO) throws -> BSANResponse<CardDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardBalance(cardDTO: CardDTO) throws -> BSANResponse<CardBalanceDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPayOff(cardDTO: CardDTO, cardDetailDTO: CardDetailDTO, amountDTO: AmountDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loadPrepaidCardData(cardDTO: CardDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getPrepaidCardData(cardDTO: CardDTO) throws -> BSANResponse<PrepaidCardDataDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateLoadPrepaidCard(cardDTO: CardDTO, amountDTO: AmountDTO, accountDTO: AccountDTO, prepaidCardDataDTO: PrepaidCardDataDTO) throws -> BSANResponse<ValidateLoadPrepaidCardDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmOTPLoadPrepaidCard(cardDTO: CardDTO, amountDTO: AmountDTO, accountDTO: AccountDTO, prepaidCardDataDTO: PrepaidCardDataDTO, validateLoadPrepaidCardDTO: ValidateLoadPrepaidCardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateUnloadPrepaidCard(cardDTO: CardDTO, amountDTO: AmountDTO, accountDTO: AccountDTO, prepaidCardDataDTO: PrepaidCardDataDTO) throws -> BSANResponse<ValidateLoadPrepaidCardDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmOTPUnloadPrepaidCard(cardDTO: CardDTO, amountDTO: AmountDTO, accountDTO: AccountDTO, prepaidCardDataDTO: PrepaidCardDataDTO, validateLoadPrepaidCardDTO: ValidateLoadPrepaidCardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateOTPPrepaidCard(cardDTO: CardDTO, signatureDTO: SignatureDTO, validateLoadPrepaidCardDTO: ValidateLoadPrepaidCardDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardDetailToken(cardDTO: CardDTO, cardTokenType: CardTokenType) throws -> BSANResponse<CardDetailTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAllCardTransactions(cardDTO: CardDTO, dateFilter: DateFilter?) throws -> BSANResponse<CardTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardTransactions(cardDTO: CardDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<CardTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardTransactions(cardDTO: CardDTO, pagination: PaginationDTO?, dateFilter: DateFilter?, cached: Bool) throws -> BSANResponse<CardTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardTransactionDetail(cardDTO: CardDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO) throws -> BSANResponse<CardTransactionDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func loadInactiveCards(inactiveCardType: InactiveCardType) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func blockCard(cardDTO: CardDTO, blockText: String, cardBlockType: CardBlockType) throws -> BSANResponse<BlockCardDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmBlockCard(cardDTO: CardDTO, signatureDTO: SignatureDTO, blockText: String, cardBlockType: CardBlockType) throws -> BSANResponse<BlockCardConfirmDTO> {
        return BSANErrorResponse(nil)
    }
    
    func activateCard(cardDTO: CardDTO, expirationDate: Date) throws -> BSANResponse<ActivateCardDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmActivateCard(cardDTO: CardDTO, expirationDate: Date, signatureDTO: SignatureDTO) throws -> BSANResponse<String> {
        return BSANErrorResponse(nil)
    }
    
    func prepareDirectMoney(cardDTO: CardDTO) throws -> BSANResponse<DirectMoneyDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateDirectMoney(cardDTO: CardDTO, amountValidatedDTO: AmountDTO) throws -> BSANResponse<DirectMoneyValidatedDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmDirectMoney(cardDTO: CardDTO, amountValidatedDTO: AmountDTO, signatureDTO: SignatureDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loadCardSuperSpeed(pagination: PaginationDTO?) throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    func loadCardSuperSpeed(pagination: PaginationDTO?, isNegativeCreditBalanceEnabled: Bool) throws -> BSANResponse<Void> {
        return BSANOkResponse(nil)
    }
    
    func changeCardAlias(cardDTO: CardDTO, newAlias: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateCVVOTP(cardDTO: CardDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateCVV(cardDTO: CardDTO) throws -> BSANResponse<SCARepresentable> {
        return BSANErrorResponse(nil)
    }
    
    func confirmCVV(cardDTO: CardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<NumberCipherDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validatePIN(cardDTO: CardDTO, cardDetailTokenDTO: CardDetailTokenDTO) throws -> BSANResponse<SignatureWithTokenDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validatePINOTP(cardDTO: CardDTO, signatureWithTokenDTO: SignatureWithTokenDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPIN(cardDTO: CardDTO, otpValidationDTO: OTPValidationDTO?, otpCode: String?) throws -> BSANResponse<NumberCipherDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getPayLaterData(cardDTO: CardDTO) throws -> BSANResponse<PayLaterDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPayLaterData(cardDTO: CardDTO, payLaterDTO: PayLaterDTO, amountDTO: AmountDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getTransactionDetailEasyPay(cardDTO: CardDTO, cardDetailDTO: CardDetailDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO, cardTransactionDetailDTO: CardTransactionDetailDTO, easyPayContractTransactionDTO: EasyPayContractTransactionDTO) throws -> BSANResponse<EasyPayDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAllTransactionsEasyPayContract(cardDTO: CardDTO, dateFilter: DateFilter?) throws -> BSANResponse<EasyPayContractTransactionListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getTransactionsEasyPayContract(cardDTO: CardDTO, pagination: PaginationDTO?, dateFilter: DateFilter?) throws -> BSANResponse<EasyPayContractTransactionListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getFeesEasyPay(cardDTO: CardDTO) throws -> BSANResponse<FeeDataDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getAmortizationEasyPay(cardDTO: CardDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO, feeDataDTO: FeeDataDTO, numFeesSelected: String) throws -> BSANResponse<EasyPayAmortizationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmationEasyPay(cardDTO: CardDTO, cardDetailDTO: CardDetailDTO, cardTransactionDTO: SANLegacyLibrary.CardTransactionDTO, cardTransactionDetailDTO: CardTransactionDetailDTO, easyPayDTO: EasyPayDTO, easyPayAmortizationDTO: EasyPayAmortizationDTO, easyPayContractTransactionDTO: EasyPayContractTransactionDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func validateModifyDebitCardLimitOTP(cardDTO: CardDTO, signatureWithToken: SignatureWithTokenDTO, debitLimitDailyAmount: AmountDTO, atmLimitDailyAmount: AmountDTO, creditLimitDailyAmount: AmountDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func validateModifyCreditCardLimitOTP(cardDTO: CardDTO, signatureWithToken: SignatureWithTokenDTO, atmLimitDailyAmount: AmountDTO, creditLimitDailyAmount: AmountDTO) throws -> BSANResponse<OTPValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmModifyDebitCardLimitOTP(cardDTO: CardDTO, otpCode: String, otpValidationDTO: OTPValidationDTO, debitLimitDailyAmount: AmountDTO, atmLimitDailyAmount: AmountDTO, cardSuperSpeedDTO: CardSuperSpeedDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func confirmModifyCreditCardLimitOTP(cardDTO: CardDTO, otpCode: String, otpValidationDTO: OTPValidationDTO, atmLimitDailyAmount: AmountDTO, cardSuperSpeedDTO: CardSuperSpeedDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getCardPendingTransactions(cardDTO: CardDTO, pagination: PaginationDTO?) throws -> BSANResponse<CardPendingTransactionsListDTO> {
        return BSANErrorResponse(nil)
    }
    
    func checkCardExtractPdf(cardDTO: CardDTO, dateFilter: DateFilter) throws -> BSANResponse<DocumentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getPaymentChange(cardDTO: CardDTO) throws -> BSANResponse<ChangePaymentDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmPaymentChange(cardDTO: CardDTO, input: ChangePaymentMethodConfirmationInput) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func loadApplePayStatus(for addedPasses: [String]) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getApplePayStatus(for card: CardDTO, expirationDate: DateModel) throws -> BSANResponse<CardApplePayStatusDTO> {
        return BSANOkResponse(nil)
    }
    
    func validateApplePay(card: CardDTO, signature: SignatureWithTokenDTO) throws -> BSANResponse<ApplePayValidationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func confirmApplePay(card: CardDTO, cardDetail: CardDetailDTO, otpValidation: OTPValidationDTO, otpCode: String, encryptionScheme: String, publicCertificates: [Data], nonce: Data, nonceSignature: Data) throws -> BSANResponse<ApplePayConfirmationDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardApplePayStatus() throws -> BSANResponse<[String : CardApplePayStatusDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getCardSettlementDetail(card: CardDTO, date: Date) throws -> BSANResponse<CardSettlementDetailDTO> {
        return BSANErrorResponse(nil)
    }
    
    func getCardSettlementListMovements(card: CardDTO, extractNumber: Int) throws -> BSANResponse<[CardSettlementMovementDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func getCardSettlementListMovementsByContract(card: CardDTO, extractNumber: Int) throws -> BSANResponse<[CardSettlementMovementWithPANDTO]> {
        return BSANErrorResponse(nil)
    }
    
    func confirmationEasyPay(input: BuyFeesParameters, card: CardDTO) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
    
    func getEasyPayFees(input: BuyFeesParameters, card: CardDTO) throws -> BSANResponse<FeesInfoDTO> {
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

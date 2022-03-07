//
//  PolandTransfersRepository.swift
//  SANPLLibrary
//
//  Created by Luis Escámez Sánchez on 27/9/21.
//

import CoreDomain

public protocol PLTransfersManagerProtocol {
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], NetworkProviderError>
    func getAccountsForCredit() throws -> Result<[AccountRepresentable], NetworkProviderError>
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[PayeeDTO], NetworkProviderError>
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<CheckInternalAccountRepresentable, NetworkProviderError>
    func getRecentRecipients() throws -> Result<[TransferRepresentable], NetworkProviderError>
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError>
    func checkFinalFee(_ parameters: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], NetworkProviderError>
    func sendConfirmation(_ parameters: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, NetworkProviderError>
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionAvailabilityRepresentable, NetworkProviderError>
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError>
    func getExchangeRates() throws -> Result<ExchangeRatesDTO, NetworkProviderError>
}

final class PLTransfersManager {
    
    private let transferDataSource: TransfersDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol
    
    private enum Constants: String {
        case channelId = "32023"
        case servicesIds = "PRZ_ELIXIR,PRZ_BLUE_CASH,PRZ_EX_ELIXIR"
    }
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.transferDataSource = TransfersDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}
    
extension PLTransfersManager: PLTransfersManagerProtocol {
    
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], NetworkProviderError> {
        let result = try self.transferDataSource.getAccountsForDebit()
        switch result {
        case .success(let accountForDebitDTO):
            return .success(accountForDebitDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getAccountsForCredit() throws -> Result<[AccountRepresentable], NetworkProviderError> {
        let result = try self.transferDataSource.getAccountsForCredit()
        switch result {
        case .success(let accountForCreditDTO):
            return .success(accountForCreditDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[PayeeDTO], NetworkProviderError> {
        let result = try self.transferDataSource.getPayees(parameters)
        switch result {
        case .success(let payeeList):
            return .success(payeeList)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getRecentRecipients() throws -> Result<[TransferRepresentable], NetworkProviderError> {
        let result = try self.transferDataSource.getRecentRecipients()
        switch result {
        case .success(let recentRecipientsDTO):
            guard let transfersList = recentRecipientsDTO.recentRecipientsData else { return .failure(NetworkProviderError.other)}
            return .success(transfersList)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<CheckInternalAccountRepresentable, NetworkProviderError> {
        let result = try self.transferDataSource.doIBANValidation(parameters)
        switch result {
        case .success(let transferNational):
            return .success(transferNational)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError> {
        let result = try self.transferDataSource.getChallenge(parameters)
        switch result {
        case .success(let challengeDTO):
            return .success(challengeDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func checkFinalFee(_ parameters: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], NetworkProviderError> {
        guard let amountValue = parameters.amount.value,
              let currency = parameters.amount.currencyRepresentable?.getSymbol()
        else { return .failure(NetworkProviderError.other) }
        let inputParameters = CheckFinalFeeParameters(
            serviceIds: parameters.servicesAvailable,
            channelId: Constants.channelId.rawValue,
            operationAmount: amountValue,
            operationCurrency: currency
        )
        let destinationAccountNumber = parameters.originAccount.checkDigits + parameters.originAccount.codBban
        let result = try self.transferDataSource.checkFinalFee(inputParameters, destinationAccount: destinationAccountNumber)
        switch result {
        case .success(let feeResponse):
            guard let feeRecords = feeResponse.records else {
                return .failure(NetworkProviderError.other)
            }
            return .success(feeRecords)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func sendConfirmation(_ parameters: GenericSendMoneyConfirmationInput) throws -> Result<ConfirmationTransferDTO, NetworkProviderError> {
        let result = try self.transferDataSource.sendConfirmation(parameters)
        switch result {
        case .success(let confirmTransactinDTO):
            return .success(confirmTransactinDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
    func checkTransaction(parameters: CheckTransactionParameters, accountReceiver: String) throws -> Result<CheckTransactionAvailabilityRepresentable, NetworkProviderError> {
        let result = try self.transferDataSource.checkTransaction(parameters: parameters, accountReceiver: accountReceiver)
        switch result {
        case .success(let availabilityResponse):
            return .success(availabilityResponse)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError> {
        guard let debitAmount = parameters.amount.value,
              let debitAmountCurrency = parameters.amount.currencyRepresentable?.currencyName else {
            return .failure(NetworkProviderError.other)
        }
        let language = try self.bsanDataProvider.getLanguageISO()
        let iban = parameters.iban.countryCode + parameters.iban.checkDigits + parameters.iban.codBban
        let amountParameters = NotifyAmountParameters(value: debitAmount, currencyCode: debitAmountCurrency)
        let derivedVariables = ["\(debitAmount)", debitAmountCurrency, iban, parameters.alias]
        let inputParameters = NotifyDeviceParameters(language: language,
                                                     notificationSchemaId: parameters.notificationSchemaId,
                                                     variables: parameters.variables ?? derivedVariables,
                                                     challenge: parameters.challenge,
                                                     softwareTokenType: nil,
                                                     amount: amountParameters)
        let result = try self.transferDataSource.notifyDevice(inputParameters)
        switch result {
        case .success(let authorizationDTO):
            return .success(authorizationDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getExchangeRates() throws -> Result<ExchangeRatesDTO, NetworkProviderError> {
        let result = try self.transferDataSource.getExchangeRates()
        switch result {
        case .success(let exchangeRatesDTO):
            return .success(exchangeRatesDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
}

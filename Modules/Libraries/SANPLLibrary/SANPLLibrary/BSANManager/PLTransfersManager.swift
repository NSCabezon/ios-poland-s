//
//  PolandTransfersRepository.swift
//  SANPLLibrary
//
//  Created by Luis Escámez Sánchez on 27/9/21.
//

import CoreDomain

public protocol PLTransfersManagerProtocol {
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], NetworkProviderError>
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[PayeeDTO], NetworkProviderError>
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<ValidateAccountTransferRepresentable, NetworkProviderError>
    func getRecentRecipients() throws -> Result<[TransferRepresentable], NetworkProviderError>
    func checkFinalFee(_ parameters: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], NetworkProviderError>
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
    
    func getPayees(_ parameters: GetPayeesParameters) throws -> Result<[PayeeDTO], NetworkProviderError> {
        let result = try self.transferDataSource.getPayees(parameters)
        switch result {
        case .success(let payeeListDTO):
            guard let payeeList = payeeListDTO.payeeList  else { return .failure(NetworkProviderError.other)}
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
    
    func doIBANValidation(_ parameters: IBANValidationParameters) throws -> Result<ValidateAccountTransferRepresentable, NetworkProviderError> {
        let result = try self.transferDataSource.doIBANValidation(parameters)
        switch result {
        case .success(let transferNational):
            let validateAccountDTO: ValidateAccountTransferDTO = ValidateAccountTransferDTO(transferNationalRepresentable: transferNational, errorCode: nil)
            return .success(validateAccountDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func checkFinalFee(_ parameters: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], NetworkProviderError> {
        guard let amountValue = parameters.amount.value, let currency = parameters.amount.currencyRepresentable?.getSymbol() else {
            return .failure(NetworkProviderError.other)
        }
        let inputParameters = CheckFinalFeeParameters(serviceIds: Constants.servicesIds.rawValue,
                                                      channelId: Constants.channelId.rawValue,
                                                      operationAmount: amountValue,
                                                      operationCurrency: currency)
        let destinationAccountNumber: String = parameters.destinationAccount.checkDigits + parameters.destinationAccount.codBban
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
}

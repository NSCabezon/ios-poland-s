//
//  PLSendMoneyDestinationUseCase.swift
//  Santander
//
//  Created by David Gálvez Alonso on 3/2/22.
//

import CoreFoundationLib
import TransferOperatives
import SANPLLibrary

final class PLSendMoneyDestinationUseCase: UseCase<SendMoneyOperativeData, SendMoneyOperativeData, DestinationAccountSendMoneyUseCaseErrorOutput>, SendMoneyDestinationUseCaseProtocol {
    
    private var bankingUtils: BankingUtilsProtocol
    private var transfersRepository: PLTransfersRepository
    private var managersProvider: PLManagersProviderProtocol
    private var localAppconfig: LocalAppConfig

    public init(dependenciesResolver: DependenciesResolver) {
        self.bankingUtils = dependenciesResolver.resolve()
        self.transfersRepository = dependenciesResolver.resolve()
        self.managersProvider = dependenciesResolver.resolve()
        self.localAppconfig = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: SendMoneyOperativeData) throws -> UseCaseResponse<SendMoneyOperativeData, DestinationAccountSendMoneyUseCaseErrorOutput> {
        requestValues.type = self.getTransferType(requestValues: requestValues)
        if let error = try self.checkInternalTransfer(requestValues: requestValues) {
            return .error(error)
        }
        guard let name = requestValues.destinationName, name.trim().count > 0 else {
            return .error(DestinationAccountSendMoneyUseCaseErrorOutput(.noToName))
        }
        try self.getSwiftBranch(requestValues: requestValues)
        return .ok(requestValues)
    }
}

private extension PLSendMoneyDestinationUseCase {
    func getTransferType(requestValues: SendMoneyOperativeData) -> SendMoneyTransferType {
        guard requestValues.countryCode == localAppconfig.countryCode else {
            return .allInternational
        }
        let localCountry = requestValues.sepaList?.allCountriesRepresentable.first(where: { $0.code == localAppconfig.countryCode  })
        if let selectedAccount = requestValues.selectedAccount,
           selectedAccount.currencyRepresentable?.currencyCode != localCountry?.currency {
            return .allInternational
        }
        if let receiveAmount = requestValues.receiveAmount,
           receiveAmount.currencyRepresentable?.currencyCode != localCountry?.currency {
            return .allInternational
        }
        return .national
    }
    
    func checkInternalTransfer(requestValues: SendMoneyOperativeData) throws -> DestinationAccountSendMoneyUseCaseErrorOutput? {
        guard requestValues.type == .national else { return nil }
        guard let iban = requestValues.destinationIBANRepresentable,
              !iban.ibanString.isEmpty,
              bankingUtils.isValidIban(ibanString: iban.ibanString) else {
            return DestinationAccountSendMoneyUseCaseErrorOutput(.ibanInvalid)
        }
        let response = try transfersRepository.checkInternalAccount(input: CheckInternalAccountInput(destinationAccount: iban))
        let checkInternalAccountDto: CheckInternalAccountRepresentable
        switch response {
        case .success(let dto):
            checkInternalAccountDto = dto
        case .failure(let error):
            return DestinationAccountSendMoneyUseCaseErrorOutput(.serviceError(errorDesc: error.localizedDescription))
        }
        requestValues.ibanValidationOutput = .data(checkInternalAccountDto)
        return nil
    }
    
    func getSwiftBranch(requestValues: SendMoneyOperativeData) throws {
        guard requestValues.type != .national else { return }
        let accountsManager = self.managersProvider.getAccountsManager()
        let accountNumber: String = {
            guard let ibanString = requestValues.destinationIBANRepresentable?.ibanString,
                  ibanString.isNotEmpty else {
                      return requestValues.destinationAccount ?? ""
                  }
            return ibanString
        }()
        let response = try accountsManager.getSwiftBranches(accountNumber: accountNumber)
        guard case .success(let dto) = response,
              let swiftBranch = dto.swiftBranchList?.first else { return }
        requestValues.bicSwift = swiftBranch.bic
        requestValues.bankName = swiftBranch.bankName?.camelCasedString
        let city = swiftBranch.city?.camelCasedString
        let address = swiftBranch.address?.camelCasedString
        let shortName = swiftBranch.shortName?.camelCasedString
        requestValues.bankAddress = "\([city, address, shortName].compactMap { $0 }.joined(separator: "\n"))"
    }
}

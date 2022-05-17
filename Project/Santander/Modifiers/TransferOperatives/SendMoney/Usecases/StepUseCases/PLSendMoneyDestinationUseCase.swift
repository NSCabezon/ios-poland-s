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
        if let error = try self.getSwiftBranch(requestValues: requestValues) {
            return .error(error)
        }
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
    
    func getSwiftBranch(requestValues: SendMoneyOperativeData) throws -> DestinationAccountSendMoneyUseCaseErrorOutput? {
        guard requestValues.type != .national else { return nil }
        let accountsManager = self.managersProvider.getAccountsManager()
        let response2 = try accountsManager.getSwiftBranches(accountNumber: requestValues.destinationAccount ?? "")
        switch response2 {
        case .success(let dto):
            // TODO: STORE DATA
            guard let swiftBranch = dto.swiftBranchList?.first else {
                // TODO: DEVOLVER UN MEJOR ERROR
                return DestinationAccountSendMoneyUseCaseErrorOutput(.serviceError(errorDesc: ""))
            }
            requestValues.bicSwift = swiftBranch.bic
            requestValues.bankName = swiftBranch.bankName
            // TODO: CONSULTAR
            requestValues.bankAddress = (swiftBranch.shortName ?? "") + "\n" + (swiftBranch.address ?? "") + "\n" + (swiftBranch.city ?? "")
            return nil
        case .failure(let error):
            return DestinationAccountSendMoneyUseCaseErrorOutput(.serviceError(errorDesc: error.localizedDescription))
        }
    }
}

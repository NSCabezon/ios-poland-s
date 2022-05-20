//
//  PLSendMoneySwiftBranchesUseCase.swift
//  Santander
//
//  Created by Angel Abad Perez on 18/5/22.
//

import CoreFoundationLib
import TransferOperatives
import SANPLLibrary

final class PLSendMoneySwiftBranchesUseCase: UseCase<SendMoneyOperativeData, SendMoneyOperativeData, StringErrorOutput>, SendMoneySwiftBranchesUseCaseProtocol {
    
    private var managersProvider: PLManagersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: SendMoneyOperativeData) throws -> UseCaseResponse<SendMoneyOperativeData, StringErrorOutput> {
        guard let countryCode = requestValues.countryCode,
              let currencyCode = requestValues.destinationCurrency?.code,
              let bicSwift = requestValues.bicSwift else {
                  return .error(StringErrorOutput(""))
              }
        let accountsManager = self.managersProvider.getAccountsManager()
        let response = try accountsManager.getSwiftBranches(parameters: SwiftBranchesParameters(countryCode: countryCode, currencyCode: currencyCode, bicSwift: bicSwift))
        guard case .success(let dto) = response,
              let swiftBranch = dto.swiftBranchList?.first else {
                  return .error(StringErrorOutput(""))
              }
        requestValues.bicSwift = swiftBranch.bic
        requestValues.bankName = swiftBranch.bankName?.camelCasedString
        let city = swiftBranch.city?.camelCasedString
        let address = swiftBranch.address?.camelCasedString
        let shortName = swiftBranch.shortName?.camelCasedString
        requestValues.bankAddress = "\([city, address, shortName].compactMap { $0 }.joined(separator: "\n"))"
        return .ok(requestValues)
    }
}

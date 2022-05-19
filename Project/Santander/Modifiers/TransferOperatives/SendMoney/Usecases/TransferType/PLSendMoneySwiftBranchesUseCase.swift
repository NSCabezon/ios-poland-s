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
                  // TODO: CHANGE
                  return .error(StringErrorOutput(""))
              }
        let accountsManager = self.managersProvider.getAccountsManager()
        let response = try accountsManager.getSwiftBranches(parameters: SwiftBranchesParameters(countryCode: countryCode, currencyCode: currencyCode, bicSwift: bicSwift))
        guard case .success(let dto) = response,
              let swiftBranch = dto.swiftBranchList?.first else {
                  // TODO: CHANGE
                  return .error(StringErrorOutput(""))
              }
        requestValues.bicSwift = swiftBranch.bic
        requestValues.bankName = swiftBranch.bankName?.camelCasedString
        requestValues.bankAddress = (swiftBranch.city?.camelCasedString ?? "") + "\n" + (swiftBranch.address?.camelCasedString ?? "") + "\n" + (swiftBranch.shortName?.camelCasedString ?? "")
        return .ok(requestValues)
    }
}

//
//  PLInternalTransferConfirmationUseCase.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 2/3/22.
//

import OpenCombine
import CoreDomain
import SANLegacyLibrary
import CoreFoundationLib
import TransferOperatives
import SANPLLibrary
import Foundation
import Operative

struct PLInternalTransferConfirmationUseCase {
    let transfersRepository: PLTransfersRepository
    let dependenciesResolver: DependenciesResolver
    
    init(dependencies: PLInternalTransferOperativeExternalDependenciesResolver) {
        self.transfersRepository = dependencies.resolve()
        self.dependenciesResolver = dependencies.resolve()
    }
}

extension PLInternalTransferConfirmationUseCase: InternalTransferConfirmationUseCase {
    func fetchConfirmation(input: InternalTransferConfirmationUseCaseInput) -> AnyPublisher<ConditionState, Error> {
        let amountData = ItAmountDataParameters(currency: input.amount.currencyRepresentable?.currencyName, amount: input.amount.value)
        guard let originAccount = input.originAccount as? PolandAccountRepresentable,
              let originIbanRepresentable = input.originAccount.ibanRepresentable, let destinationIbanRepresentable = input.destinationAccount.ibanRepresentable else { return Just(.failure).setFailureType(to: Error.self).eraseToAnyPublisher() }
        let customerAddressData = CustomerAddressDataParameters(customerName: input.name,
                                                                city: nil,
                                                                street: nil,
                                                                zipCode: nil,
                                                                baseAddress: nil)
        let signData = SignDataParameters(securityLevel: 2048)
        let originIBAN: String = originIbanRepresentable.countryCode + originIbanRepresentable.checkDigits + originIbanRepresentable.codBban
        let destinationIBAN = destinationIbanRepresentable.countryCode + destinationIbanRepresentable.checkDigits + destinationIbanRepresentable.codBban
        let debitAccounData = ItAccountDataParameters(accountNo: originIBAN,
                                                      accountName: nil,
                                                      accountSequenceNumber: originAccount.sequencerNo,
                                                      accountType: originAccount.accountType)
        
        let creditAccountData = ItAccountDataParameters(accountNo: destinationIBAN,
                                                        accountName: (input.name ?? ""),
                                                        accountSequenceNumber: 0,
                                                        accountType: 90)
        let transactionType = internalTransferMatrix(input)
        let time = input.time?.toString(format: "YYYY-MM-dd")
        let genericSendMoneyConfirmationInput = GenericSendMoneyConfirmationInput(customerAddressData: customerAddressData,
                                                                                  debitAmountData: amountData,
                                                                                  creditAmountData: amountData,
                                                                                  debitAccountData: debitAccounData,
                                                                                  creditAccountData: creditAccountData,
                                                                                  signData: signData,
                                                                                  title: input.concept,
                                                                                  type: transactionType,
                                                                                  transferType: PolandTransferType.zero.serviceString,
                                                                                  valueDate: time)
        return transfersRepository.sendConfirmation(input: genericSendMoneyConfirmationInput)
            .tryMap { result in
                if let state = result.state, let confirmationResult = ConfirmationResultType(rawValue: state) {
                    switch confirmationResult {
                    case .accepted:
                        return .success
                    default:
                        return .failure
                    }
                } else {
                    return .failure
                }
            }
            .eraseToAnyPublisher()
    }
}

private extension PLInternalTransferConfirmationUseCase {
    func internalTransferMatrix(_ input: InternalTransferConfirmationUseCaseInput) -> String? {
        let matrix = TranferTypeMatrixEvaluator(isSourceCurrencyPLN: input.originAccount.currencyRepresentable?.currencyType == .złoty,
                                   isDestinationAccountInternal: true,
                                                isDestinationAccountCurrencyPLN: input.destinationAccount.currencyRepresentable?.currencyType == .złoty,
                                   isOwner: true,
                                   isCountryPLN: true)
        return matrix.evaluateTransactionType()?.asDto.rawValue
    }
}

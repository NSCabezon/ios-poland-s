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
    func fetchPreSetup(input: SendMoneyConfirmationStepUseCaseInput) -> AnyPublisher<ConditionState, Error> {
        //let transferType = dependenciesResolver.resolve(forOptionalType: SendMoneyModifierProtocol.self)?.transferTypeFor(onePayType: input.type, subtype: input.subType?.serviceString ?? "")
        let amountData = ItAmountDataParameters(currency: input.amount.currencyRepresentable?.currencyName, amount: input.amount.value)
        guard let originAccount = input.originAccount as? PolandAccountRepresentable,
              let ibanRepresentable = input.originAccount.ibanRepresentable else { return Just(.failure).setFailureType(to: Error.self).eraseToAnyPublisher() }
        let customerAddressData = CustomerAddressDataParameters(customerName: input.name,
                                                                city: nil,
                                                                street: nil,
                                                                zipCode: nil,
                                                                baseAddress: nil)
        let signData = SignDataParameters(securityLevel: 2048)
        let originIBAN: String = ibanRepresentable.countryCode + ibanRepresentable.checkDigits + ibanRepresentable.codBban
        let destinationIBAN = input.destinationIBAN.countryCode + input.destinationIBAN.checkDigits + input.destinationIBAN.codBban
        let debitAccounData = ItAccountDataParameters(accountNo: originIBAN,
                                                      accountName: nil,
                                                      accountSequenceNumber: originAccount.sequencerNo,
                                                      accountType: originAccount.accountType)
        
        let creditAccountData = ItAccountDataParameters(accountNo: destinationIBAN,
                                                        accountName: (input.name ?? "") + (input.payeeSelected?.payeeAddress ?? ""),
                                                        accountSequenceNumber: 0,
                                                        accountType: 90)
        var valueDate: String?
        if case .day(let date) = input.time {
            valueDate = date.toString(format: "YYYY-MM-dd")
        }
        let prueba = Date().toString(format: "YYYY-MM-dd")
        
        let genericSendMoneyConfirmationInput = GenericSendMoneyConfirmationInput(customerAddressData: customerAddressData,
                                                                                  debitAmountData: amountData,
                                                                                  creditAmountData: amountData,
                                                                                  debitAccountData: debitAccounData,
                                                                                  creditAccountData: creditAccountData,
                                                                                  signData: signData,
                                                                                  title: input.concept,
                                                                                  type: "ONEAPP_OWN_CURRENCY_TRANSACTION",// OWN_TRANSACTION input.transactionType,
                                                                                  transferType: PolandTransferType.zero.serviceString,
                                                                                  valueDate: prueba)//cambiar
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

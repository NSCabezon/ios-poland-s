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
    
    init(dependencies: PLInternalTransferOperativeExternalDependenciesResolver) {
        self.transfersRepository = dependencies.resolve()
    }
}

extension PLInternalTransferConfirmationUseCase: InternalTransferConfirmationUseCase {
    func fetchConfirmation(input: InternalTransferConfirmationUseCaseInput) -> AnyPublisher<Void, Error> {
        let debitAmountData = ItAmountDataParameters(
            currency: input.debitAmount.currencyRepresentable?.currencyCode,
            amount: input.debitAmount.value
        )
        let creditAmountData = ItAmountDataParameters(
            currency: input.creditAmount.currencyRepresentable?.currencyCode,
            amount: input.creditAmount.value
        )
        guard let originAccount = input.originAccount as? PolandAccountRepresentable,
              let destinationAccount = input.destinationAccount as? PolandAccountRepresentable,
              let originIbanRepresentable = input.originAccount.ibanRepresentable,
              let destinationIbanRepresentable = input.destinationAccount.ibanRepresentable
        else {
            return Fail(error: NSError(description: "")).eraseToAnyPublisher()
        }
        let customerAddressData = CustomerAddressDataParameters(
            customerName: input.name,
            city: nil,
            street: nil,
            zipCode: nil,
            baseAddress: nil
        )
        let signData = SignDataParameters(securityLevel: 1)
        let originIBAN: String = originIbanRepresentable.countryCode + originIbanRepresentable.checkDigits + originIbanRepresentable.codBban
        let destinationIBAN = destinationIbanRepresentable.countryCode + destinationIbanRepresentable.checkDigits + destinationIbanRepresentable.codBban
        let debitAccounData = ItAccountDataParameters(
            accountNo: originIBAN,
            accountName: nil,
            accountSequenceNumber: originAccount.sequencerNo,
            accountType: originAccount.accountType
        )
        let creditAccountData = ItAccountDataParameters(
            accountNo: destinationIBAN,
            accountName: (input.name ?? ""),
            accountSequenceNumber: destinationAccount.sequencerNo,
            accountType: destinationAccount.accountType
        )
        let transactionType = internalTransferMatrix(input)
        let time = input.time?.toString(format: "YYYY-MM-dd")
        let genericSendMoneyConfirmationInput = GenericSendMoneyConfirmationInput(
            customerAddressData: customerAddressData,
            debitAmountData: debitAmountData,
            creditAmountData: creditAmountData,
            debitAccountData: debitAccounData,
            creditAccountData: creditAccountData,
            signData: signData,
            title: input.concept,
            type: transactionType,
            transferType: PolandTransferType.zero.serviceString,
            valueDate: time
        )
        return sendConfirmation(genericSendMoneyConfirmationInput)
    }
    
    func internalTransferMatrix(_ input: InternalTransferConfirmationUseCaseInput) -> String? {
        let matrix = TranferTypeMatrixEvaluator(
            isSourceCurrencyPLN: input.originAccount.currencyRepresentable?.currencyType == .złoty,
            isDestinationAccountInternal: true,
            isDestinationAccountCurrencyPLN: input.destinationAccount.currencyRepresentable?.currencyType == .złoty,
            isOwner: true,
            isCountryPLN: true
        )
        return matrix.evaluateTransactionType()?.asDto.rawValue
    }
}

private extension PLInternalTransferConfirmationUseCase {
    func sendConfirmation(_ input: GenericSendMoneyConfirmationInput) -> AnyPublisher<Void, Error> {
        return transfersRepository.sendConfirmation(input: input)
            .mapError { error -> Error in
                guard let error = error as? NetworkProviderError,
                      let errorDTO: PLErrorDTO = error.getErrorBody(),
                      let parsedError = SendMoneyConfirmationErrorType(errorDTO.errorCode2)
                else {
                    return NSError(description: "")
                }
                return parsedError
            }
            .tryMap { result in
                guard let state = result.state,
                      let confirmationResult = ConfirmationResultType(rawValue: state),
                      case .accepted = confirmationResult
                else { throw NSError(description: "") }
                return ()
            }
            .eraseToAnyPublisher()
    }
}

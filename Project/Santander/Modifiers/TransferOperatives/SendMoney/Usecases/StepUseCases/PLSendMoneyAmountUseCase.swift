//
//  PLSendMoneyAmountUseCase.swift
//  Santander
//
//  Created by David Gálvez Alonso on 9/2/22.
//

import TransferOperatives
import SANLegacyLibrary
import SANPLLibrary
import CoreFoundationLib
import CoreDomain

final class PLSendMoneyAmountUseCase: UseCase<SendMoneyOperativeData, SendMoneyOperativeData, StringErrorOutput>, SendMoneyAmountUseCaseProtocol {
    let transfersRepository: PLTransfersRepository
    
    init(dependenciesResolver: DependenciesResolver) {
        self.transfersRepository = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: SendMoneyOperativeData) throws -> UseCaseResponse<SendMoneyOperativeData, StringErrorOutput> {
        guard let sourceAccount = requestValues.selectedAccount as? PolandAccountRepresentable
        else { return .error(StringErrorOutput(nil)) }
        let isCreditCard = sourceAccount.type == .creditCard
        let matrixEvaluation = evaluateMatrix(sourceAccount: sourceAccount, requestValues: requestValues)
        guard let matrixTransferType = matrixEvaluation.0, let transactionType = matrixEvaluation.1 else { return .error(StringErrorOutput(nil)) }
        guard matrixTransferType.toTransferType == .one else {
            requestValues.specialPricesOutput = SendMoneyTransferTypeUseCaseOkOutput(
                isCreditCardAccount: isCreditCard,
                fees: [
                    SendMoneyTransferTypeFee(type: matrixTransferType.toTransferType, fee: nil)
                ],
                transactionType: transactionType
            )
            requestValues.selectedTransferType = requestValues.specialPricesOutput?.fees.first
            return .ok(requestValues)
        }
        var fees: [SendMoneyTransferTypeFee] = []
        var availableTransferTypes: [PolandTransferType] = [.one]
        if matrixTransferType == .oneWithOptional {
            availableTransferTypes.append(contentsOf: (try? getAvailableTransferTypes(requestValues: requestValues)) ?? [])
        }
        var feesResponse: [PolandTransferType: AmountRepresentable] = [:]
        if !isCreditCard,
           let finalFees = try? getFinalFees(requestValues: requestValues, availableServices: availableTransferTypes) {
            feesResponse = finalFees
        }
        fees += availableTransferTypes.map { type in
            return SendMoneyTransferTypeFee(
                type: type,
                fee: feesResponse[type]
            )
        }
        requestValues.specialPricesOutput = SendMoneyTransferTypeUseCaseOkOutput(
            isCreditCardAccount: isCreditCard,
            fees: fees,
            transactionType: transactionType
        )
        return .ok(requestValues)
    }
}

private extension PLSendMoneyAmountUseCase {
    enum Constants {
        static let plnCurrencyCode: String = "PLN"
        static let plCountryCode: String = "PL"
    }
    
    func evaluateMatrix(sourceAccount: PolandAccountRepresentable, requestValues: SendMoneyOperativeData) -> (TranferTypeMatrixEvaluator.MatrixTransferType?, PolandTransactionType?) {
        guard case .data(let data) = requestValues.ibanValidationOutput,
                let checkInternalAccountRepresentable = data as? CheckInternalAccountRepresentable
        else {
            return (nil, nil)
        }
        let matrix = TranferTypeMatrixEvaluator(
            isSourceCurrencyPLN: sourceAccount.currencyRepresentable?.currencyType == .złoty,
            isDestinationAccountInternal: !checkInternalAccountRepresentable.isExternal,
            isDestinationAccountCurrencyPLN: requestValues.destinationCurrency?.code == Constants.plnCurrencyCode,
            isOwner: requestValues.isOwner,
            isCountryPLN: requestValues.country?.code == Constants.plCountryCode
        )
        return (matrix.evaluateTransferType(), matrix.evaluateTransactionType())
    }
    
    func getFinalFees(requestValues: SendMoneyOperativeData, availableServices: [PolandTransferType]) throws -> [PolandTransferType: AmountRepresentable] {
        guard let originIban = requestValues.selectedAccount?.ibanRepresentable,
              let amount = requestValues.amount
        else { return [:] }
        let feesResponse = try transfersRepository.getFinalFee(
            input: CheckFinalFeeInput(
                originAccount: originIban,
                amount: amount,
                servicesAvailable: availableServices.map { $0.asFinalFeeInputParameter }.joined(separator: ",")
            )
        )
        var fees: [PolandTransferType: AmountRepresentable] = [:]
        switch feesResponse {
        case .success(let feesDto):
            fees = parseFees(feesDto)
        case .failure:
            break
        }
        return fees
    }
    
    func getAvailableTransferTypes(requestValues: SendMoneyOperativeData) throws -> [PolandTransferType] {
        guard let destinationAccount = requestValues.destinationIBANRepresentable else {
            return []
        }
        let availableResponse = try transfersRepository.checkTransactionAvailability(
            input: CheckTransactionAvailabilityInput(
                destinationAccount: destinationAccount,
                transactionAmount: requestValues.amount
            )
        )
        var availableTransferTypes: [PolandTransferType] = []
        switch availableResponse {
        case .success(let dto):
            if dto.expressElixirStatusCode == 0 {
                availableTransferTypes.append(.eight)
            }
            if dto.blueCashStatusCode == 0 {
                availableTransferTypes.append(.a)
            }
        case .failure:
            break
        }
        return availableTransferTypes
    }
    
    func parseFees(_ fees: [CheckFinalFeeRepresentable]) -> [PolandTransferType: AmountRepresentable] {
        var doFees: [PolandTransferType: AmountRepresentable] = [:]
        for fee in fees {
            guard let serviceId = fee.serviceId, let amount = fee.feeAmount else { continue }
            doFees[PolandTransferType(serviceId: serviceId)] = amount
        }
        return doFees
    }
}

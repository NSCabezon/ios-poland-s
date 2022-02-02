//
//  SendMoneyTransferTypeUseCase.swift
//  Santander
//
//  Created by José Norberto Hidalgo Romero on 5/10/21.
//

import TransferOperatives
import SANLegacyLibrary
import SANPLLibrary
import CoreFoundationLib
import CoreDomain

final class SendMoneyTransferTypeUseCase: UseCase<SendMoneyTransferTypeUseCaseInputProtocol, SendMoneyTransferTypeUseCaseOkOutputProtocol, StringErrorOutput>, SendMoneyTransferTypeUseCaseProtocol {
    let transfersRepository: PLTransfersRepository
    
    init(dependenciesResolver: DependenciesResolver) {
        self.transfersRepository = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: SendMoneyTransferTypeUseCaseInputProtocol) throws -> UseCaseResponse<SendMoneyTransferTypeUseCaseOkOutputProtocol, StringErrorOutput> {
        guard let requestValues = requestValues as? SendMoneyTransferTypeUseCaseInput,
              let sourceAccount = requestValues.sourceAccount as? PolandAccountRepresentable
        else { return .error(StringErrorOutput(nil)) }
        let isCreditCard = sourceAccount.type == .creditCard
        let matrixEvaluation = evaluateMatrix(sourceAccount: sourceAccount, requestValues: requestValues)
        guard let matrixTransferType = matrixEvaluation.0, let transactionType = matrixEvaluation.1 else { return .error(StringErrorOutput(nil)) }
        guard matrixTransferType.toTransferType == .one else {
            return .ok(
                SendMoneyTransferTypeUseCaseOkOutput(
                    isCreditCardAccount: isCreditCard,
                    fees: [
                        SendMoneyTransferTypeFee(type: matrixTransferType.toTransferType, fee: nil)
                    ],
                    transactionType: transactionType
                )
            )
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
        return .ok(
            SendMoneyTransferTypeUseCaseOkOutput(
                isCreditCardAccount: isCreditCard,
                fees: fees,
                transactionType: transactionType
            )
        )
    }
}

private extension SendMoneyTransferTypeUseCase {
    enum Constants {
        static let plnCurrencyCode: String = "PLN"
        static let plCountryCode: String = "PL"
    }
    
    func evaluateMatrix(sourceAccount: PolandAccountRepresentable, requestValues: SendMoneyTransferTypeUseCaseInput) -> (TranferTypeMatrixEvaluator.MatrixTransferType?, PolandTransactionType?) {
        let matrix = TranferTypeMatrixEvaluator(
            isSourceCurrencyPLN: sourceAccount.currencyRepresentable?.currencyType == .złoty,
            isDestinationAccountInternal: !requestValues.checkInternalAccountRepresentable.isExternal,
            isDestinationAccountCurrencyPLN: requestValues.destinationAccountCurrency.code == Constants.plnCurrencyCode,
            isOwner: requestValues.isOwner,
            isCountryPLN: requestValues.country.code == Constants.plCountryCode
        )
        return (matrix.evaluateTransferType(), matrix.evaluateTransactionType())
    }
    
    func getFinalFees(requestValues: SendMoneyTransferTypeUseCaseInput, availableServices: [PolandTransferType]) throws -> [PolandTransferType: AmountRepresentable] {
        guard let originIban = requestValues.sourceAccount.ibanRepresentable else { return [:] }
        let feesResponse = try transfersRepository.getFinalFee(
            input: CheckFinalFeeInput(
                originAccount: originIban,
                amount: requestValues.amount,
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
    
    func getAvailableTransferTypes(requestValues: SendMoneyTransferTypeUseCaseInput) throws -> [PolandTransferType] {
        let availableResponse = try transfersRepository.checkTransactionAvailability(
            input: CheckTransactionAvailabilityInput(
                destinationAccount: requestValues.destinationIban,
                transactionAmount: requestValues.amount.value ?? 0
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

struct SendMoneyTransferTypeUseCaseInput: SendMoneyTransferTypeUseCaseInputProtocol {
    public let sourceAccount: AccountRepresentable
    public let destinationIban: IBANRepresentable
    public let destinationAccountCurrency: CurrencyInfoRepresentable
    public let isOwner: Bool
    public let amount: AmountRepresentable
    public let country: CountryInfoRepresentable
    public let checkInternalAccountRepresentable: CheckInternalAccountRepresentable
}

struct SendMoneyTransferTypeUseCaseOkOutput: SendMoneyTransferTypeUseCaseOkOutputProtocol {    
    var shouldShowSpecialPrices: Bool {
        return fees.contains { ($0.type as? PolandTransferType) == .one }
    }
    let isCreditCardAccount: Bool
    let fees: [SendMoneyTransferTypeFee]
    let transactionType: PolandTransactionType?
    var transactionTypeString: String? {
        return transactionType?.asDto.rawValue
    }
}

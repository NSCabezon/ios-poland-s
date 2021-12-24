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
import Commons

final class SendMoneyTransferTypeUseCase: UseCase<SendMoneyTransferTypeUseCaseInputProtocol, SendMoneyTransferTypeUseCaseOkOutputProtocol, StringErrorOutput>, SendMoneyTransferTypeUseCaseProtocol {
    let transfersRepository: PLTransfersRepository
    
    init(dependenciesResolver: DependenciesResolver) {
        self.transfersRepository = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: SendMoneyTransferTypeUseCaseInputProtocol) throws -> UseCaseResponse<SendMoneyTransferTypeUseCaseOkOutputProtocol, StringErrorOutput> {
        guard let requestValues = requestValues as? SendMoneyTransferTypeUseCaseInput,
              let sourceAccount = requestValues.sourceAccount as? PolandAccountRepresentable
        else { return .error(StringErrorOutput(nil)) }
        guard sourceAccount.type != .creditCard else {
            return .ok(SendMoneyTransferTypeUseCaseOkOutput(
                isCreditCardAccount: true,
                fees: [SendMoneyTransferTypeFee(type: PolandTransferType.creditCardAccount, fee: nil)],
                transactionType: nil
            ))
        }
        let matrixEvaluation = evaluateMatrix(sourceAccount: sourceAccount, requestValues: requestValues)
        guard let transferType = matrixEvaluation.0, let transactionType = matrixEvaluation.1
        else { return .error(StringErrorOutput(nil)) }
        guard transferType.toTransferType == .one else {
            return .ok(SendMoneyTransferTypeUseCaseOkOutput(
                isCreditCardAccount: false,
                fees: [SendMoneyTransferTypeFee(type: transferType.toTransferType, fee: nil)],
                transactionType: transactionType
            ))
        }
        
        let fees = try getFinalfees(requestValues: requestValues)
        guard fees[.one] != nil
        else { return .error(StringErrorOutput(nil)) }
        guard transferType == .oneWithOptional else {
            return .ok(SendMoneyTransferTypeUseCaseOkOutput(
                isCreditCardAccount: false,
                fees: [SendMoneyTransferTypeFee(type: transferType.toTransferType, fee: fees[transferType.toTransferType])],
                transactionType: transactionType
            ))
        }
        let availableTransferTypes = try getAvailableTransferTypes(requestValues: requestValues, fees: fees)
        return .ok(SendMoneyTransferTypeUseCaseOkOutput(
            isCreditCardAccount: false,
            fees: availableTransferTypes.map { type in
                return SendMoneyTransferTypeFee(
                    type: type,
                    fee: fees[type]
                )
            },
            transactionType: transactionType
        ))
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
    
    func getFinalfees(requestValues: SendMoneyTransferTypeUseCaseInput) throws -> [PolandTransferType: AmountRepresentable] {
        guard let originIban = requestValues.sourceAccount.ibanRepresentable else { fatalError() }
        let feesResponse = try transfersRepository.getFinalFee(
            input: CheckFinalFeeInput(
                originAccount: originIban,
                amount: requestValues.amount
            )
        )
        var fees: [PolandTransferType: AmountRepresentable] = [:]
        switch feesResponse {
        case .success(let feesDto):
            fees = parseFees(feesDto)
        case .failure(let error):
            throw error
        }
        return fees
    }
    
    func getAvailableTransferTypes(requestValues: SendMoneyTransferTypeUseCaseInput, fees: [PolandTransferType: AmountRepresentable]) throws -> [PolandTransferType] {
        let availableResponse = try transfersRepository.checkTransactionAvailability(
            input: CheckTransactionAvailabilityInput(
                destinationAccount: requestValues.destinationIban,
                transactionAmount: requestValues.amount.value ?? 0
            )
        )
        var availableTransferTypes: [PolandTransferType] = [.one]
        switch availableResponse {
        case .success(let dto):
            if fees[.eight] != nil && dto.expressElixirStatusCode == 0 {
                availableTransferTypes.append(.eight)
            }
            if fees[.a] != nil && dto.blueCashStatusCode == 0 {
                availableTransferTypes.append(.a)
            }
        case .failure(let error):
            throw error
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
        return fees.contains { [.one, .creditCardAccount].contains($0.type as? PolandTransferType) }
    }
    let isCreditCardAccount: Bool
    let fees: [SendMoneyTransferTypeFee]
    let transactionType: PolandTransactionType?
    var transactionTypeString: String? {
        return transactionType?.asDto.rawValue
    }
}

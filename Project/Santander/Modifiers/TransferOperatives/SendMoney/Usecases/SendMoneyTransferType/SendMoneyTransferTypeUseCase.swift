//
//  SendMoneyTransferTypeUseCase.swift
//  Santander
//
//  Created by José Norberto Hidalgo Romero on 5/10/21.
//

import TransferOperatives
import SANLegacyLibrary
import SANPLLibrary
import DomainCommon
import CoreDomain
import Commons
import Models

final class SendMoneyTransferTypeUseCase: UseCase<SendMoneyTransferTypeUseCaseInputProtocol, SendMoneyTransferTypeUseCaseOkOutputProtocol, StringErrorOutput>, SendMoneyTransferTypeUseCaseProtocol {
    let transfersRepository: PLTransfersRepository
    
    init(dependenciesResolver: DependenciesResolver) {
        self.transfersRepository = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: SendMoneyTransferTypeUseCaseInputProtocol) throws -> UseCaseResponse<SendMoneyTransferTypeUseCaseOkOutputProtocol, StringErrorOutput> {
        guard let requestValues = requestValues as? SendMoneyTransferTypeUseCaseInput,
              let sourceAccount = requestValues.sourceAccount as? PolandAccountRepresentable
        else { return .error(StringErrorOutput(nil)) }
        guard sourceAccount.type != .creditCard
        else { return .ok(SendMoneyTransferTypeUseCaseOkOutput(fees: [SendMoneyTransferTypeFee(type: PolandTransferType.creditCardAccount, fee: nil)])) }
        guard let transferType = evaluateMatrix(sourceAccount: sourceAccount, requestValues: requestValues)
        else { return .error(StringErrorOutput(nil)) }
        guard transferType.toTransferType == .one
        else { return .ok(SendMoneyTransferTypeUseCaseOkOutput(fees: [SendMoneyTransferTypeFee(type: transferType.toTransferType, fee: nil)])) }
        do {
            let fees = try getFinalfees(requestValues: requestValues)
            guard fees[.one] != nil
            else { return .error(StringErrorOutput(nil)) }
            guard transferType == .oneWithOptional
            else { return .ok(SendMoneyTransferTypeUseCaseOkOutput(fees: [SendMoneyTransferTypeFee(type: transferType.toTransferType, fee: fees[transferType.toTransferType])])) }
            let availableTransferTypes = try getAvailableTransferTypes(requestValues: requestValues, fees: fees)
            return .ok(SendMoneyTransferTypeUseCaseOkOutput(fees: availableTransferTypes.map { type in
                return SendMoneyTransferTypeFee(
                    type: type,
                    fee: fees[type]
                )
            }))
        } catch let error {
            return .error(StringErrorOutput(error.localizedDescription))
        }
    }
}

private extension SendMoneyTransferTypeUseCase {
    enum Constants {
        static let plnCurrencyCode: String = "PLN"
        static let plCountryCode: String = "PL"
    }
    
    func evaluateMatrix(sourceAccount: PolandAccountRepresentable, requestValues: SendMoneyTransferTypeUseCaseInput) -> TranferTypeMatrixEvaluator.MatrixTransferType? {
        let matrix = TranferTypeMatrixEvaluator(
            isSourceCurrencyPLN: sourceAccount.currencyRepresentable?.currencyType == .złoty,
            isDestinationAccountInternal: requestValues.isDestinationAccountInternal,
            isDestinationAccountCurrencyPLN: requestValues.destinationAccountCurrency.code == Constants.plnCurrencyCode,
            isOwner: requestValues.isOwner,
            isCountryPLN: requestValues.country.code == Constants.plCountryCode
        )
        return matrix.evaluate()
    }
    
    func getFinalfees(requestValues: SendMoneyTransferTypeUseCaseInput) throws -> [PolandTransferType: AmountRepresentable] {
        let feesResponse = try transfersRepository.getFinalFee(
            input: CheckFinalFeeInput(
                destinationAccount: requestValues.destinationIban,
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
}

private extension SendMoneyTransferTypeUseCase {
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
    public let isDestinationAccountInternal: Bool
    public let isOwner: Bool
    public let amount: AmountRepresentable
    public let country: CountryInfoRepresentable
}

struct SendMoneyTransferTypeUseCaseOkOutput: SendMoneyTransferTypeUseCaseOkOutputProtocol {
    var shouldShowSpecialPrices: Bool {
        return fees.contains { ($0.type as? PolandTransferType) == .one }
    }
    let fees: [SendMoneyTransferTypeFee]
}

enum PolandTransferType: SendMoneyTransferTypeProtocol {
    case creditCardAccount
    case zero
    case one
    case four
    case eight
    case a
    
    init(serviceId: TransferFeeServiceIdDTO) {
        switch serviceId {
        case .elixir:
            self = .one
        case .expressElixir:
            self = .eight
        case .bluecash:
            self = .a
        }
    }
}

extension PolandTransferType {
    var title: String? {
        switch self {
        case .one:
            return localized("sendMoney_label_standardSent")
        case .eight:
            return localized("sendMoney_label_immediateSend")
        case .a:
            return localized("sendMoney_label_expressDelivery")
        case .creditCardAccount:
            return localized("sendMoney_title_creditCardAccount")
        default:
            return nil
        }
    }
    
    var subtitle: String? {
        switch self {
        case .one:
            return localized("sendType_text_standar")
        case .eight:
            return localized("sendType_text_inmediate")
        case .a:
            return localized("sendType_text_express")
        case .creditCardAccount:
            return localized("sendMoney_text_creditCardAccount")
        default:
            return nil
        }
    }
    
    var limitAmount: AmountRepresentable {
        switch self {
        case .eight:
            return AmountDTO(value: Decimal(5000), currency: .create(.złoty))
        case .a:
            return AmountDTO(value: Decimal(20000), currency: .create(.złoty))
        default:
            return AmountDTO(value: .zero, currency: .create(.złoty))
        }
    }
}

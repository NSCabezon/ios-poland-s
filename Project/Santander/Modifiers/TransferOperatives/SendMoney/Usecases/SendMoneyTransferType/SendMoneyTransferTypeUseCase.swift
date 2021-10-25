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
        else { return .ok(SendMoneyTransferTypeUseCaseOkOutput(transfer: [.creditCardAccount], fees: [:])) }
        guard let transferType = evaluateMatrix(sourceAccount: sourceAccount, requestValues: requestValues)
        else { return .error(StringErrorOutput(nil)) }
        guard transferType.toTransferType == .one
        else { return .ok(SendMoneyTransferTypeUseCaseOkOutput(transfer: [transferType.toTransferType], fees: [:])) }
        let fees = getFinalfees()
        guard fees[.one] != nil
        else { return .error(StringErrorOutput(nil)) }
        guard transferType == .oneWithOptional
        else { return .ok(SendMoneyTransferTypeUseCaseOkOutput(transfer: [.one], fees: fees)) }
        let availableTransferTypes = getAvailableTransferTypes()
        return .ok(SendMoneyTransferTypeUseCaseOkOutput(transfer: availableTransferTypes, fees: fees))
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
    
    func getFinalfees() -> [PolandTransferType: AmountRepresentable] {
        //TODO: Call API2 to get final fees
        return [
            .one: AmountDTO(value: 0, currency: .create(.złoty)),
            .eight: AmountDTO(value: 27, currency: .create(.złoty)),
            .a: AmountDTO(value: 6, currency: .create(.złoty))
        ]
    }
    
    func getAvailableTransferTypes() -> [PolandTransferType] {
        //TODO: Call API1 to get availability of types A/8
        return [.one, .eight, .a]
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
        return transfer.contains(.one)
    }
    let transfer: [PolandTransferType]
    let fees: [PolandTransferType: AmountRepresentable]
}

enum PolandTransferType {
    case creditCardAccount
    case zero
    case one
    case four
    case eight
    case a
}

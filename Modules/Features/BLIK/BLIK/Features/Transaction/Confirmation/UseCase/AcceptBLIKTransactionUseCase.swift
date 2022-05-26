import CoreFoundationLib
import Foundation
import SANPLLibrary
import PLCommons

protocol AcceptBLIKTransactionProtocol: UseCase<AcceptBLIKTransactionUseCaseInput, Void, StringErrorOutput> {}

final class AcceptBLIKTransactionUseCase: UseCase<AcceptBLIKTransactionUseCaseInput, Void, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let transactionParametersProvider: PLTransactionParametersProviderProtocol

    init(dependenciesResolver: DependenciesResolver) {
        managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        transactionParametersProvider = dependenciesResolver.resolve(for: PLTransactionParametersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: AcceptBLIKTransactionUseCaseInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        
        let transactionParametersInput = PLDomesticTransactionParametersInput(
            debitAccountNumber: "",
            creditAccountNumber: "",
            debitAmount: requestValues.transaction.amount,
            userID: "",
            merchantId: requestValues.transaction.merchant?.merchantId ?? "",
            transactionTime: requestValues.transaction.transactionRawValue.time
        )
        let transactionParameters = transactionParametersProvider.getTransactionParameters(
            type: .codeBlik(transactionParametersInput)
        )
        let parameters = BlikAcceptTransactionParameters(
            trnId: requestValues.trnId,
            trnDate: requestValues.trnDate,
            transactionParameters: transactionParameters
        )
        let result = try managersProvider
            .getBLIKManager()
            .acceptTransaction(parameters)
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            let blikError = BlikError(with: error.getErrorBody())
            guard let blikError = blikError,
                  blikError.errorCode1 == .customerTypeDisabled else {
                return .error(.init(error.localizedDescription))
            }
            return .error(.init(blikError.errorKey + "." + "\(blikError.errorCode2.rawValue)"))
        }
    }
}

extension AcceptBLIKTransactionUseCase: AcceptBLIKTransactionProtocol {}


struct AcceptBLIKTransactionUseCaseInput {
    let trnId: Int
    let trnDate: String
    let transaction: Transaction
}

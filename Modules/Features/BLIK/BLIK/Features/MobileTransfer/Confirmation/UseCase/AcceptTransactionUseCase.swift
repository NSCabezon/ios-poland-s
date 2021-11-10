import Foundation
import Models
import Commons
import DomainCommon
import SANPLLibrary
import SANLegacyLibrary

protocol AcceptTransactionProtocol: UseCase<AcceptTransactionUseCaseInput, AcceptTransactionUseCaseOkOutput, StringErrorOutput> {}

final class AcceptTransactionUseCase: UseCase<AcceptTransactionUseCaseInput, AcceptTransactionUseCaseOkOutput, StringErrorOutput> {
    
    private let managersProvider: PLManagersProviderProtocol
    private let mapper: MobileTransferSummaryMapping
    
    init(dependenciesResolver: DependenciesResolver,
         mapper: MobileTransferSummaryMapping = MobileTransferSummaryMapper()) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.mapper = mapper
    }
    
    override func executeUseCase(requestValues: AcceptTransactionUseCaseInput) throws -> UseCaseResponse<AcceptTransactionUseCaseOkOutput, StringErrorOutput> {
  
        let form = requestValues.form
        let account = form.account

        let amountData: AcceptDomesticTransactionParameters.AmountData = .init(
            amount: form.amount,
            currency: CurrencyType.złoty.name
        )

        let accountData: AcceptDomesticTransactionParameters.DebitAccountData = .init(
            accountType: account.accountType,
            accountSequenceNumber: account.accountSequenceNumber,
            accountNo: account.accountNumberUnformatted
        )
        
        let accountNo = String(requestValues.dstAccNo.dropFirst(2))
        let creditAccountData: AcceptDomesticTransactionParameters.CreditAccountData = .init(
            accountType: 90,
            accountSequenceNumber: 0,
            accountNo: accountNo,
            accountName: form.recipientName
        )

        let date = form.date?.toString(format: TimeFormat.yyyyMMdd.rawValue) ?? ""
        let transferType: AcceptDomesticTransactionParameters.TransferType = requestValues.isDstAccInternal ? .INTERNAL : .BLIK_P2P
        
        let result = try managersProvider
            .getBLIKManager()
            .acceptTransfer(AcceptDomesticTransactionParameters(title: form.title,
                                                                type: .BLIK_P2P_TRANSACTION,
                                                                transferType: transferType,
                                                                dstPhoneNo: form.trimmedPhoneNumber,
                                                                valueDate: date,
                                                                debitAmountData: amountData,
                                                                debitAccountData: accountData,
                                                                creditAccountData: creditAccountData)
            )


        switch result {
        case .success(let result):
            return .ok(.init(summary: mapper.map(summary: result, transferType: transferType)))
        case .failure(let error):
            let blikError = BlikError(with: error.getErrorBody())
            guard blikError?.errorCode1 == .customerTypeDisabled else {
                return .error(.init(nil))
            }
            return .error(.init(blikError?.errorKey))
        }
    }
}

extension AcceptTransactionUseCase: AcceptTransactionProtocol {}


struct AcceptTransactionUseCaseInput {
    let form: MobileTransferViewModel
    let isDstAccInternal: Bool
    let dstAccNo: String
}

struct AcceptTransactionUseCaseOkOutput {
    let summary: MobileTransferSummary
}

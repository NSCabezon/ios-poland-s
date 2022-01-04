import Foundation
import CoreFoundationLib
import Commons
import SANPLLibrary
import SANLegacyLibrary
import PLCommons

protocol AcceptTransactionProtocol: UseCase<AcceptTransactionUseCaseInput, AcceptTransactionUseCaseOkOutput, StringErrorOutput> {}

final class AcceptTransactionUseCase: UseCase<AcceptTransactionUseCaseInput, AcceptTransactionUseCaseOkOutput, StringErrorOutput> {
    
    private let managersProvider: PLManagersProviderProtocol
    private let transactionParametersProvider: PLTransactionParametersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        self.transactionParametersProvider = dependenciesResolver.resolve(for: PLTransactionParametersProviderProtocol.self)
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: AcceptTransactionUseCaseInput) throws -> UseCaseResponse<AcceptTransactionUseCaseOkOutput, StringErrorOutput> {
  
        let form = requestValues.form
        let account = form.account
        let amountData: AcceptDomesticTransactionParameters.AmountData = .init(
            amount: form.amount,
            currency: CurrencyType.złoty.name
        )
        let debitAccountFormated = IBANFormatter.formatIbanToNrb(
            for: account.number
        )
        let accountData: AcceptDomesticTransactionParameters.DebitAccountData = .init(
            accountType: account.accountType,
            accountSequenceNumber: account.accountSequenceNumber,
            accountNo: account.number,
            accountName: account.name
        )
        let creditAccountFormated = IBANFormatter.formatIbanToNrb(
            for: requestValues.dstAccNo
        )
        let creditAccountData: AcceptDomesticTransactionParameters.CreditAccountData = .init(
            accountType: 90,
            accountSequenceNumber: 0,
            accountNo: creditAccountFormated,
            accountName: form.recipientName
        )

        let date = form.date?.toString(format: TimeFormat.yyyyMMdd.rawValue) ?? ""
        let transferType: AcceptDomesticTransactionParameters.TransferType = requestValues.isDstAccInternal ? .INTERNAL : .BLIK_P2P
  
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return .error(.init("userId not exists"))
        }
        
        let transactionParametersInput = PLDomesticTransactionParametersInput(
            debitAccountNumber: debitAccountFormated,
            creditAccountNumber: creditAccountFormated,
            debitAmount: form.amount,
            userID: String(describing: userId)
        )
        
        let transactionParameters = transactionParametersProvider.getTransactionParameters(
            type: .blikP2P(transactionParametersInput)
        )
        
        let result = try managersProvider
            .getBLIKManager()
            .acceptTransfer(
                AcceptDomesticTransactionParameters(
                    title: form.title,
                    type: .BLIK_P2P_TRANSACTION,
                    transferType: transferType,
                    dstPhoneNo: form.trimmedPhoneNumber,
                    valueDate: date,
                    debitAmountData: amountData,
                    debitAccountData: accountData,
                    creditAccountData: creditAccountData,
                    creditAmountData: amountData
                ),
                transactionParameters: transactionParameters
            )


        switch result {
        case .success(let result):
            return .ok(.init(summary: result, transferType: transferType))
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
    let summary: AcceptDomesticTransferSummaryDTO
    let transferType: AcceptDomesticTransactionParameters.TransferType
}

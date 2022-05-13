import TransferOperatives
import SANPLLibrary

struct SendMoneyTransferTypeUseCaseInputAdapter: SendMoneyTransferTypeUseCaseInputAdapterProtocol {
    func toUseCaseInput(operativeData: SendMoneyOperativeData) -> SendMoneyTransferTypeUseCaseInputProtocol? {
        guard let selectedAccount = operativeData.selectedAccount,
              let destinationIban = operativeData.destinationIBANRepresentable,
              let destinationAccountCurrency = operativeData.destinationCurrency,
              let amount = operativeData.amount,
              let country = operativeData.country,
              case .data(let data) = operativeData.ibanValidationOutput,
              let checkInternalAccountRepresentable = data as? CheckInternalAccountRepresentable
        else { return nil }
        return SendMoneyTransferTypeUseCaseInput(
            sourceAccount: selectedAccount,
            destinationIban: destinationIban,
            destinationAccountCurrency: destinationAccountCurrency,
            isOwner: operativeData.isOwner,
            amount: amount,
            country: country,
            checkInternalAccountRepresentable: checkInternalAccountRepresentable
        )
    }
}

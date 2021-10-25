import TransferOperatives

struct SendMoneyTransferTypeUseCaseInputAdapter: SendMoneyTransferTypeUseCaseInputAdapterProtocol {
    func toUseCaseInput(operativeData: SendMoneyOperativeData) -> SendMoneyTransferTypeUseCaseInputProtocol? {
        guard let selectedAccount = operativeData.selectedAccount,
              let destinationIban = selectedAccount.ibanRepresentable,
              let destinationAccountCurrency = operativeData.destinationAccountCurrency,
              let isDestinationAccountInternal = operativeData.isDestinationAccountInternal,
              let amount = operativeData.amount,
              let country = operativeData.country
        else { return nil }
        return SendMoneyTransferTypeUseCaseInput(
            sourceAccount: selectedAccount,
            destinationIban: destinationIban,
            destinationAccountCurrency: destinationAccountCurrency,
            isDestinationAccountInternal: isDestinationAccountInternal,
            isOwner: operativeData.isOwner,
            amount: amount,
            country: country
        )
    }
}

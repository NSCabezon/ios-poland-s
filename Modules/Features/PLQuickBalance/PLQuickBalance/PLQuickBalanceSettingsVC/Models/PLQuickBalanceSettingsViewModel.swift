import SANPLLibrary

public class PLQuickBalanceSettingsViewModel {
    var isOn: Bool
    var allAccounts: [PLQuickBalanceSettingsAccountModel]?
    var selectedMainAccount: PLQuickBalanceSettingsAccountModel?
    var selectedSecondAccount: PLQuickBalanceSettingsAccountModel?
    var amount: Double?

    init(isOn: Bool,
         allAccounts: [PLQuickBalanceSettingsAccountModel]? = nil,
         selectedAccount: PLQuickBalanceSettingsAccountModel? = nil,
         selectedSecondAccount: PLQuickBalanceSettingsAccountModel? = nil,
         amount: Double) {
        self.isOn = isOn
        self.allAccounts = allAccounts
        self.selectedMainAccount = selectedAccount
        self.selectedSecondAccount = selectedSecondAccount
        self.amount = amount
    }
}

extension PLQuickBalanceSettingsViewModel {
    static func mapAccount(_ accountDTO: AccountDTO?) -> PLQuickBalanceSettingsAccountModel? {
        guard
            let id = accountDTO?.number,
            let name = accountDTO?.name?.userDefined ?? accountDTO?.name?.description,
            let number = accountDTO?.number?.suffix(4)
        else { return nil }
        return PLQuickBalanceSettingsAccountModel(id: id,
                                                  name: name,
                                                  number: String(number))
    }

    static func mapCreditCard(_ cardDTO: CardDTO?) -> PLQuickBalanceSettingsAccountModel? {
        guard
            let id = cardDTO?.productId?.id,
            let name = cardDTO?.name?.userDefined ?? cardDTO?.name?.description,
            let number = cardDTO?.panIdentifier?.suffix(4)
        else { return nil }
        return PLQuickBalanceSettingsAccountModel(id: id,
                                                  name: name,
                                                  number: String(number))
    }

    static func mapSaving(_ savingDTO: SavingDTO?) -> PLQuickBalanceSettingsAccountModel? {
        guard
            let id = savingDTO?.number,
            let name = savingDTO?.name?.userDefined ?? savingDTO?.name?.description,
            let number = savingDTO?.number.suffix(4)
        else { return nil }
        return PLQuickBalanceSettingsAccountModel(id: id,
                                                  name: name,
                                                  number: String(number))
    }

}

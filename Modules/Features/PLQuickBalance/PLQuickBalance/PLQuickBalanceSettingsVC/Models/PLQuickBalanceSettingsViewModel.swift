import SANPLLibrary

public class PLQuickBalanceSettingsViewModel {
    var isOn: Bool
    var allAccounts: [PLQuickBalanceSettingsAccountModel]?
    var selectedMainAccount: PLQuickBalanceSettingsAccountModel?
    var selectedSecondAccount: PLQuickBalanceSettingsAccountModel?
    var amount: Int?

    init(isOn: Bool,
         allAccounts: [PLQuickBalanceSettingsAccountModel]? = nil,
         selectedAccount: PLQuickBalanceSettingsAccountModel? = nil,
         selectedSecondAccount: PLQuickBalanceSettingsAccountModel? = nil,
         amount: Int) {
        self.isOn = isOn
        self.allAccounts = allAccounts
        self.selectedMainAccount = selectedAccount
        self.selectedSecondAccount = selectedSecondAccount
        self.amount = amount
    }
}

extension PLQuickBalanceSettingsViewModel {
    static func map(_ accountDTO: AccountDTO?) -> PLQuickBalanceSettingsAccountModel? {
        guard
            let id = accountDTO?.number,
            let name = accountDTO?.name?.userDefined ?? accountDTO?.name?.description,
            let number = accountDTO?.number?.suffix(4)
        else { return nil }
        return PLQuickBalanceSettingsAccountModel(id: id,
                                                  name: name,
                                                  number: String(number))
    }
}

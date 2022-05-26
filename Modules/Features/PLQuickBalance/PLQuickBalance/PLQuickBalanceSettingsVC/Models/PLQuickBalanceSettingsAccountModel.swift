public class PLQuickBalanceSettingsAccountModel: Equatable {
    let id: String
    let name: String
    let number: String

    init(id: String, name: String, number: String) {
        self.id = id
        self.name = name
        self.number = number
    }

    public static func == (lhs: PLQuickBalanceSettingsAccountModel, rhs: PLQuickBalanceSettingsAccountModel) -> Bool {
        return lhs.id == rhs.id
    }
}

import Foundation

public typealias PLQuickBalanceDTO = [PLQuickBalanceDTOElement]

public struct PLQuickBalanceDTOElement: Codable {
    public let accountDescription: String?
    public let currencyCode: String?
    public let type: String?
    public let value: Double?
    public let lastTransaction: LastTransaction?
}

public struct LastTransaction: Codable {
    public let debitAddress: String?
    public let title: String?
    public let amount: Double?
    public let valueDate: String?
}

public struct PLGetQuickBalanceSettingsDTO: Codable {
    public let accountNo: String
    public let amount: Double?
}

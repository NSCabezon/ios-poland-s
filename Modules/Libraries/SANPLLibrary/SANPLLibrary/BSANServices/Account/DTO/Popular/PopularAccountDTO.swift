
import Foundation

public struct PopularAccountDTO: Codable {
    public let number: String?
    public let type: Int?
    public let currencyCode: String?
    public let branchCode: String?
    public let name: String?
    public let address: PopularAccountAdressDTO?
    public let transactionTitle: String?
    public let transferType: String?
    public let validFrom: String?
    public let validTo: String?
    public let options: Int?
    public let additionalInfo: String?
    public let timestamp: Int?
    public let typeName: String?
    public let typeOptions: Int?
    public let drTransactionMask: Int?
    public let crTransactionMask: Int?
}

public struct PopularAccountAdressDTO: Codable {
    public let street: String?
    public let city: String?
    public let zipCode: String?
}

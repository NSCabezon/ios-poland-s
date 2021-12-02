import Foundation
import PLUI
import CoreDomain
import PLCommons

public struct MobileTransfer {
    public let amount: Decimal?
    public let title: String?
    public let account: AccountForDebit
    public let recipientName: String?
    public let phoneNumber: String?
    public let date: Date?
}

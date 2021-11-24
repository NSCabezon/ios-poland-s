import Foundation
import PLUI
import CoreDomain

public struct MobileTransfer {
    public let amount: Decimal?
    public let title: String?
    public let account: SelectableAccountViewModel
    public let recipientName: String?
    public let phoneNumber: String?
    public let date: Date?
}

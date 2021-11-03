import Foundation
import PLUI

public struct MobileTransfer {
    public let amount: Double?
    public let title: String?
    public let account: SelectableAccountViewModel
    public let recipientName: String?
    public let phoneNumber: String?
    public let date: Date?
}

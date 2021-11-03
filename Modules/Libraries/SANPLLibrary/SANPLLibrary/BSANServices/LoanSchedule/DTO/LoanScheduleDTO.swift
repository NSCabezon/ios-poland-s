import Foundation

public struct LoanScheduleDTO: Codable {
    public let paymentSchedule: PaymentSchedule?
    public let correlationId: String?
}

public extension LoanScheduleDTO {
    struct Currency: Codable {
        public let currencyCode: String?
        public let currencyCodeLocal: String?
        public let currencyNumber: String?
        public let currencyNumberLocal: String?
    }
    
    struct ScheduleItem: Codable {
        public let date: String?
        public let amount: Decimal?
        public let principalAmount: Decimal?
        public let interestAmount: Decimal?
        public let balanceAfterPayment: Decimal?
    }
    
    struct PaymentSchedule: Codable {
        public let currency: Currency?
        public let scheduleItems: [ScheduleItem]?
    }
}

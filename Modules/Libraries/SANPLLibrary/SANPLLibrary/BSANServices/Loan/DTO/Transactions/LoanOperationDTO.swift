//
//  LoanOperationDTO.swift
//  SANPLLibrary
//
import CoreDomain
import CoreFoundationLib
import Foundation

public struct LoanOperationDTO: Codable {
    public let balance: Double?
    public let operationId: LoanOperationIdDTO?
    public let dateValue: String?
    public let amount: Double?
    public let interestAmount: Double?
    public let title: String?
    public let psCode: String?
    public let statementNo: Int?
    public let extraData: LoanOperationExtraDataDTO?
    public let csrData: LoanOperationCsrDataDTO?
    
    enum CodingKeys: String, CodingKey {
        case balance = "balance"
        case operationId = "operationId"
        case dateValue = "valueDate"
        case amount = "amount"
        case interestAmount = "interestAmount"
        case title = "title"
        case psCode = "psCode"
        case statementNo = "statementNo"
        case extraData = "extraData"
        case csrData = "csrData"
    }
}

extension LoanOperationDTO: LoanTransactionRepresentable {
    public var operationDate: Date? {
        return Date().parse(operationId?.postingDate ?? "", format: .YYYYMMDD)
    }
    
    public var amountRepresentable: AmountRepresentable? {
        let amount = Decimal(amount ?? 0)
        let interestAmount = Decimal(interestAmount ?? 0)
        let amountValue = amount + interestAmount
        return AmountDTO(value: amountValue, currencyRepresentable: currency)
    }
    
    public var description: String? {
        return title
    }
    
    public var bankOperationRepresentable: BankOperationRepresentable? {
        return nil
    }
    
    public var balanceRepresentable: AmountRepresentable? {
        return nil
    }
    
    public var dgoNumberRepresentable: DGONumberRepresentable? {
        return nil
    }
    
    public var titular: String? {
        return nil
    }
    
    public var valueDate: Date? {
        Date().parse(dateValue ?? "", format: .YYYYMMDD)
    }
    
    public var transactionNumber: String? {
        return "\(operationId?.postingDate ?? "")/\(operationId?.operationLP ?? 0)"
    }
}

private extension LoanOperationDTO {
    var currency: CurrencyRepresentable? {
        guard let operationCurrency = extraData?.operationCurrency else {
            return nil
        }
        let currencyType = CurrencyType.parse(operationCurrency)
        return CurrencyDTO(currencyName: operationCurrency, currencyType: currencyType)
    }
}

public struct LoanOperationIdDTO: Codable {
    public let postingDate: String?
    public let operationLP: Int?
}

public struct LoanOperationExtraDataDTO: Codable {
    public let extendedTitle: String?
    public let branchId: Int?
    public let sideDebit: LoanOperationSideDTO?
    public let sideCredit: LoanOperationSideDTO?
    public let operationSubCode: Int?
    public let sepaData: String?
    public let operationType: String?
    public let operationCurrency: String?
}

public struct LoanOperationSideDTO: Codable {
    public let address: String?
    public let accountNo: String?
    public let exchangeRate: String?
}

public struct LoanOperationCsrDataDTO: Codable {
    public let csrId: Int?
    public let csrOperationId: String?
    public let csrReference: String?
}

//
//  PLAccountTransactionDetailShareableInfo.swift
//  Santander
//

import Account
import CoreFoundationLib

final class PLAccountTransactionDetailShareableInfo: AccountTransactionDetailShareableInfoProtocol {
    func getShareableInfo(description: String?,
                          alias: String?,
                          amount: NSAttributedString?,
                          info: [(title: String, description: String)],
                          operationDate: String?,
                          valueDate: String?) -> String {
        var shareableInfo = ""
        shareableInfo.append("\(description ?? "")\n")
        shareableInfo.append("\(alias ?? "")\n")
        shareableInfo.append("\(localized("summary_item_quantity")) \(amount?.string ?? "")\n")
        shareableInfo.append("\(localized("transaction_label_operationDate")) \(operationDate ?? "")\n")
        shareableInfo.append("\(localized("transaction_label_valueDate")) \(valueDate ?? "")\n")
        info.forEach { shareableInfo.append("\($0.title) \($0.description)\n")}

        return shareableInfo
    }
}

//
//  AccountInfo.swift
//  SANPLLibrary
//

import Foundation

public struct AccountInfo: Codable {
    public var accountDetailDictionary: [String : AccountDetailDTO] = [:]
    public var swiftBranchesDictionary: [String : SwiftBranchesDTO] = [:]
    public var withHoldingListDictionary: [String : WithholdingListDTO] = [:]
    public var transactionsDictionary: [String : AccountTransactionsDTO] = [:]
}

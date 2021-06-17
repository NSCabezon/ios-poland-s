//
//  LoanInfo.swift
//  SANPLLibrary
//

import Foundation

public struct LoanInfo: Codable {
    public var loanOperationsDictionary: [String : LoanOperationListDTO] = [:]
    public var loanDetailDictionary: [String : LoanDetailDTO] = [:]
}

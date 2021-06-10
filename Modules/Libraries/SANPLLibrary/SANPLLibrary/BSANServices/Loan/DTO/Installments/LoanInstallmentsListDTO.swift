//
//  LoanInstallmentsListDTO.swift
//  SANPLLibrary
//

import Foundation

public struct LoanInstallmentsListDTO: Codable {
    public let installments: [LoanInstallmentDTO]?
    public let page: [LoanInstallmentPageDTO]?
}

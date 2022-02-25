//
//  ExpensesChartDTO.swift
//  SANPLLibrary
//

public struct ExpensesChartDTO: Codable {
    public let entries: [ExpensesChartEntryDTO]?
}

public struct ExpensesChartEntryDTO: Codable {
    public let month: String?
    public let income: Double?
    public let outlay: Double?
    public let count: Int?
}

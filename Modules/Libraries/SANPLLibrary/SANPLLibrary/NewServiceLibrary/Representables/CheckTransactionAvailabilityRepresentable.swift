//
//  File.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import CoreDomain

public protocol CheckTransactionAvailabilityRepresentable {
    var expressElixirStatusCode: Int? { get }
    var blueCashStatusCode: Int? { get }
}

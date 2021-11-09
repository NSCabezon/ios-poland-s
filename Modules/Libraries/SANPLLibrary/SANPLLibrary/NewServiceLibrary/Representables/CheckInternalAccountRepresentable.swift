//
//  CheckInternalAccountRepresentable.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import CoreDomain

public protocol CheckInternalAccountRepresentable {
    var currencyCode: String? { get }
    var isExternal: Bool { get }
}

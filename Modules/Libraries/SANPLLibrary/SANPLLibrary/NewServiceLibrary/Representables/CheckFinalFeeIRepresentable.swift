//
//  File.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 11/10/21.
//

import CoreDomain

public protocol CheckFinalFeeRepresentable {
    var serviceId: TransferFeeServiceIdDTO? { get }
    var feeAmount: AmountRepresentable? { get }
}

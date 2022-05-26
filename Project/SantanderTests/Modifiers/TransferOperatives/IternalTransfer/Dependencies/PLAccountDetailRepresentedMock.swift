//
//  PLAccountDetailRepresentedMock.swift
//  SantanderTests
//
//  Created by Carlos Monfort Gómez on 24/5/22.
//

import Foundation
import SANPLLibrary

struct PLAccountDetailRepresentedMock: PLAccountDetailRepresentable {
    var number: String?
    var ownerRepresentable: PLAccountDetailOwnerRepresentable?
    var branchRepresentable: PLAccountDetailBranchRepresentable?
    var currency: Int?
    var currencyCode: String?
    
    init(name: String?) {
        ownerRepresentable = PLAccountDetailOwnerRepresentedMock(customerName: name,
                                                                 street: nil,
                                                                 city: nil)
    }
}

struct PLAccountDetailOwnerRepresentedMock: PLAccountDetailOwnerRepresentable {
    var customerName: String?
    var street: String?
    var city: String?
}

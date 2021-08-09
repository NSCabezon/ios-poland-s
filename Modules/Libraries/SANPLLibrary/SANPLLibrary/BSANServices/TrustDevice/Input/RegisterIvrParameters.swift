//
//  RegisterIvrParameters.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 2/8/21.
//

import Foundation

public struct RegisterIvrParameters: Encodable {

    let appId: String

    public init(appId: String) {
        self.appId = appId
    }
}

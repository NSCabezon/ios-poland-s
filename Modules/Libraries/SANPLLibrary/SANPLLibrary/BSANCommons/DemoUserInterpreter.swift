//
//  DemoUserInterpreter.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

public protocol DemoUserProtocol {
    func isDemoUser(userName: String) -> Bool
    var isDemoModeAvailable: Bool { get }
}

public class DemoUserInterpreter: DemoUserProtocol {
    public var isDemoModeAvailable: Bool
    static let demoUser = "12345678Z"
    let bsanDataProvider: BSANDataProvider
    let defaultDemoUser: String

    public init(bsanDataProvider: BSANDataProvider, defaultDemoUser: String, demoModeAvailable: Bool = false) {
        self.bsanDataProvider = bsanDataProvider
        self.defaultDemoUser = defaultDemoUser
        self.isDemoModeAvailable = demoModeAvailable
    }

    public func isDemoUser(userName: String) -> Bool {
        return userName.uppercased() == DemoUserInterpreter.demoUser
    }
}

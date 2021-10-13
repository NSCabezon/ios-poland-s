//
//  AppInfo.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 21/9/21.
//

import Foundation
public struct AppInfo: Codable {
    public var isFirstLaunch: Bool?
    
    public init(isFirstLaunch: Bool?) {
        self.isFirstLaunch = isFirstLaunch
    }
}

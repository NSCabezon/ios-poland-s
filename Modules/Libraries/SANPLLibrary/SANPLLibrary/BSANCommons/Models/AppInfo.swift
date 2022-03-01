//
//  AppInfo.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 21/9/21.
//

import Foundation
public struct AppInfo: Codable {
    public var isFirstLaunch: Bool?
    public var acceptedTermsVersion: Int
    
    public init(isFirstLaunch: Bool?, acceptedTermsVersion: Int = 0) {
        self.isFirstLaunch = isFirstLaunch
        self.acceptedTermsVersion = acceptedTermsVersion
    }
}

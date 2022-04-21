//
//  DefaultsStorable.swift
//  PLCommons
//
//  Created by 188216 on 23/03/2022.
//

import Foundation

@propertyWrapper
public struct DefaultsStorable<T> {
    // MARK: Properties
    
    private let defaults = UserDefaults.standard
    public let key: String
    public let defaultValue: T
    
    public var wrappedValue: T {
        get {
            return defaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
    
    // MARK: Lifecycle
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

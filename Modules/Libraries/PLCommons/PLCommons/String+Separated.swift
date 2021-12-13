//
//  String+Separated.swift
//  PLCommons
//
//  Created by 188216 on 01/12/2021.
//

import Foundation

extension String {
    /// Adds a separator at every N characters
    /// - Parameters:
    ///   - separator: the String value to be inserted, to separate the groups
    ///   - stride: the number of characters in the group, before a separator is inserted
    /// - Returns: Returns a String which includes a `separator` String at every `stride` number of characters.
    public func separated(by separator: String, stride: Int) -> String {
        return enumerated().map { $0.isMultiple(of: stride) && ($0 != 0) ? "\(separator)\($1)" : String($1) }.joined()
    }
}

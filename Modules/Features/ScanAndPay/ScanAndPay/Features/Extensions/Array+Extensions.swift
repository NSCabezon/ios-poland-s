//
//  Array+Extensions.swift
//  ScanAndPay
//
//  Created by 188216 on 12/04/2022.
//

import Foundation

extension Array {
    /// Returns a new array whith elements from the input array separated by the separator
    func separated(by separator: @autoclosure () -> Element) -> Self {
        return self.map { [$0, separator()] }
            .flatMap { $0 }
            .dropLast()
    }
}

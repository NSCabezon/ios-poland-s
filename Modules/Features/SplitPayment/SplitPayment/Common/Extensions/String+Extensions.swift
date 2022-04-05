//
//  String+Extensions.swift
//  SplitPayment
//
//  Created by 189501 on 02/04/2022.
//

import Foundation

extension String {
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

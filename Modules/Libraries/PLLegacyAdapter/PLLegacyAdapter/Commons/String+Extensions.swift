//
//  String+Extension.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 29/7/21.
//

import Foundation

extension String {
    public func getDate(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from:self)
    }
}

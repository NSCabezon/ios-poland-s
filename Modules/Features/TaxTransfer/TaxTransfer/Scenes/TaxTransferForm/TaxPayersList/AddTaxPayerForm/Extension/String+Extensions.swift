//
//  String+Extensions.swift
//  TaxTransfer
//
//  Created by 187831 on 07/02/2022.
//

extension String {
    subscript(safe index: Int) -> String? {
        guard let charIndex = self.index(startIndex, offsetBy: index, limitedBy: endIndex),
              self.indices.contains(charIndex) else {
            return nil
        }
        
        return String(self[charIndex])
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

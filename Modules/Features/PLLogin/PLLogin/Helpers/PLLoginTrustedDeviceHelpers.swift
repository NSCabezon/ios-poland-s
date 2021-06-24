//
//  PLLoginTrustedDeviceHelpers.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 15/6/21.
//

import Foundation

class PLLoginTrustedDeviceHelpers {
    
    /**
     Returns a length 16 string
     Characters are repeated to complete 16 characters string
     or first 16 characters of the string if string.count >= 16
     */
    static func length16Password(_ password: String?) -> String? {
        guard let password = password, password.count > 0 else { return nil }
        let constantLenght = 16
        let substring16:(String) -> (String?) = { password in
            guard let substring = password.substring(0, constantLenght) else { return nil }
            return substring
        }
        guard password.count < constantLenght else { return substring16(password) }
        var longerPassword = password
        while longerPassword.count < constantLenght { longerPassword.append(password) }
        return substring16(longerPassword)
    }

    /**
     Returns an array of bytes secure random
     - Parameter bytesNumber: Number of bytes that will be returned
     i.e: bytesNumber = 16 -> Will return an array of 16 bytes  (16 bytes * 8 bit/byte = 128 bits)
     */
    static func secureRandom(bytesNumber: Int) -> [UInt8]? {
        var bytes = [UInt8](repeating: 0, count: bytesNumber)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

        return status == errSecSuccess ? bytes : nil
    }
}

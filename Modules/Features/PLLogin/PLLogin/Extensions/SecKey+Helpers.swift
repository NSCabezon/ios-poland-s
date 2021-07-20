//
//  SecKey+Helpers.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 7/7/21.
//

import Foundation

extension SecKey {
    var base64: String? {
        var error:Unmanaged<CFError>?
        guard let cfdata = SecKeyCopyExternalRepresentation(self, &error)  else { return nil }
        let data:Data = cfdata as Data
        let b64Key = data.base64EncodedString()
        return b64Key
    }

    static func secKey(with base64: String, isPrivate: Bool) -> SecKey? {
        guard let keyData = Data(base64Encoded: base64) else { return nil }
        let key = SecKeyCreateWithData(keyData as NSData, [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: isPrivate ? kSecAttrKeyClassPrivate : kSecAttrKeyClassPublic,
        ] as NSDictionary, nil)!
        print(key)
        return key
    }
}

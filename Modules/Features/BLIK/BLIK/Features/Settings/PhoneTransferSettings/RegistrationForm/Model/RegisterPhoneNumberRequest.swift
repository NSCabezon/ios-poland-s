//
//  RegisterPhoneNumberRequest.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 24/08/2021.
//

struct RegisterPhoneNumberRequest: Codable {
    let accountNo: String
    let authCode: String?
}

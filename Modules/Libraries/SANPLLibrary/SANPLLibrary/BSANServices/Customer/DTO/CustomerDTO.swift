//
//  CustomerDTO.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 7/9/21.
//

import Foundation

public struct CustomerDTO: Codable {
    public let contactData: ContactDetailDTO?
    public let address: AddressDetailDTO?
    public let correspondenceAddress: AddressDetailDTO?
    public let marketingSegment: String?
    public let cif: Decimal?
    public let firstName: String?
    public let secondName: String?
    public let lastName: String?
    public let dateOfBirth: String?
    public let pesel: String?
    public let citizenship: String?
}

public struct ContactDetailDTO: Codable {
    public let phoneNo: PhoneDetailDTO?
    public let email: String?
}

public struct PhoneDetailDTO: Codable {
    public let prefix: String?
    public let number: String?
}

public struct AddressDetailDTO: Codable {
    public let name: String?
    public let city: String?
    public let street: String?
    public let propertyNo: String?
    public let zip: String?
    public let countryCode: String?
    public let voivodship: String?
}

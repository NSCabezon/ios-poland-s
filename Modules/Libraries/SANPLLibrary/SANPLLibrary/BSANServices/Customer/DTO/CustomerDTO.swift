//
//  CustomerDTO.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 7/9/21.
//

import SANLegacyLibrary

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
    public let customerContexts: [ContextDTO]?
    public let smsTokenNo: String?
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

public struct ContextDTO: Codable {
    public let name: String?
    public let type: ContextType?
    public let ownerId: Decimal?
    public let selected: Bool?
}

public enum ContextType: String, Codable {
    case INDIVIDUAL, PROXY, MINI_COMPANY, COMPANY
}

extension CustomerDTO: PersonalBasicInfoRepresentable {

    public var mainAddress: String? {
        address?.name
    }

    public var addressNodes: [String]? {
        [address?.name ?? "",
         address?.city ?? "",
         address?.street ?? "",
         address?.propertyNo ?? "",
         address?.zip ?? "",
         address?.countryCode ?? "",
         address?.voivodship ?? ""]
    }
    
    public var correspondenceAddressNodes: [String]? {
        [
            correspondenceAddress?.name ?? "",
            correspondenceAddress?.city ?? "",
            correspondenceAddress?.street ?? "",
            correspondenceAddress?.propertyNo ?? "",
            correspondenceAddress?.zip ?? "",
            correspondenceAddress?.countryCode ?? "",
            correspondenceAddress?.voivodship ?? ""
        ]
    }

    public var documentType: DocumentType? {
        nil
    }

    public var documentNumber: String? {
        nil
    }

    public var birthdayDate: Date? {
        nil
    }

    public var birthString: String? {
        nil
    }

    public var phoneNumber: String? {
        contactData?.phoneNo?.number
    }

    public var contactHourFrom: Date? {
        nil
    }

    public var contactHourTo: Date? {
        nil
    }

    public var email: String? {
        return contactData?.email
    }
    
    public var smsPhoneNumber: String? {
        smsTokenNo
    }
}

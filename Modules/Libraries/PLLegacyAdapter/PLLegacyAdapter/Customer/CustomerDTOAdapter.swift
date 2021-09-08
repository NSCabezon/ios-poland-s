//
//  CustomerDTOAdapter.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 8/9/21.
//

import SANPLLibrary
import SANLegacyLibrary

final class CustomerDTOAdapter {
    static func adaptPLCustomer(_ plCustomer: SANPLLibrary.CustomerDTO) -> SANLegacyLibrary.PersonBasicDataDTO {
        var personBasicDataDTO = SANLegacyLibrary.PersonBasicDataDTO()
        let addressName = plCustomer.address?.name?.capitalized ?? ""
        let addressCity = plCustomer.address?.city?.capitalized ?? ""
        let addressStreet = plCustomer.address?.street?.capitalized ?? ""
        let addressPropertyNo = plCustomer.address?.propertyNo?.capitalized ?? ""
        let addressZip = plCustomer.address?.zip?.capitalized ?? ""
        let countryCode = plCustomer.address?.countryCode?.capitalized ?? ""
        let voivodship = plCustomer.address?.voivodship?.capitalized ?? ""
        let addressArray: [String] = [addressName, addressCity, addressStreet, addressPropertyNo, addressZip, countryCode, voivodship]
        personBasicDataDTO.mainAddress = plCustomer.address?.name?.capitalized ?? ""
        personBasicDataDTO.addressNodes = addressArray
        personBasicDataDTO.documentNumber = plCustomer.pesel?.capitalized ?? ""
        personBasicDataDTO.birthString = plCustomer.dateOfBirth?.capitalized ?? ""
        personBasicDataDTO.phoneNumber = plCustomer.contactData?.phoneNo?.number ?? ""
        personBasicDataDTO.email = plCustomer.contactData?.email?.capitalized ?? ""
        return personBasicDataDTO
    }
}

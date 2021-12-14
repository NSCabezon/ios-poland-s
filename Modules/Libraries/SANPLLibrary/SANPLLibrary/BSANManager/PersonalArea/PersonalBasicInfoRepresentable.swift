//
//  PersonalBasicInfoRepresentable.swift
//  SANPLLibrary
//
//  Created by Rubén Muñoz López on 20/8/21.
//

import SANLegacyLibrary

 public protocol PersonalBasicInfoRepresentable: Codable {
     var mainAddress: String? { get }
     var addressNodes: [String]? { get }
     var correspondenceAddressNodes: [String]? { get }
     var documentType: DocumentType? { get }
     var documentNumber: String? { get }
     var birthdayDate: Date? { get }
     var birthString: String? { get }
     var phoneNumber: String? { get }
     var contactHourFrom: Date? { get }
     var contactHourTo: Date? { get }
     var email: String? { get }
 }

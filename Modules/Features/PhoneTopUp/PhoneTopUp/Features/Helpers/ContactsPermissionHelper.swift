//
//  ContactsPermissionHelper.swift
//  PhoneTopUp
//
//  Created by 188216 on 04/01/2022.
//

import Contacts
import Foundation

protocol ContactsPermissionHelperProtocol: AnyObject {
    func authorizeContactsUse(completion: @escaping (Bool) -> Void)
}

final class ContactsPermissionHelper: ContactsPermissionHelperProtocol {
    func authorizeContactsUse(completion: @escaping (Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { access, error in
                DispatchQueue.main.async {
                    completion(access)
                }
            }
        case .authorized:
            completion(true)
        default:
            completion(false)
        }
    }
}

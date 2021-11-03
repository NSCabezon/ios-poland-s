import Foundation
import Contacts

class CNContactStoreMock: CNContactStore {
    
    override func enumerateContacts(with fetchRequest: CNContactFetchRequest, usingBlock block: @escaping (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws {
        
        let contact = CNMutableContact()
        contact.givenName = "Johnny"
        contact.familyName = "Appleased"
        contact.phoneNumbers = [CNLabeledValue(label: "label",
                                               value: CNPhoneNumber(stringValue: "123 456 789")),
                                CNLabeledValue(label: "label",
                                               value: CNPhoneNumber(stringValue: "987 654 321"))]
        
        let pointer = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 0)
        block(contact, pointer)
    }
}

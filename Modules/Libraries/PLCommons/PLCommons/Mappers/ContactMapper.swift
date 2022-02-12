import Contacts

public protocol ContactMapping {
    func map(contacts: [CNContact]) -> [MobileContact]
}

public final class ContactMapper: ContactMapping {
    
    public init() {}
    
    public func map(contacts: [CNContact]) -> [MobileContact] {
        var mappedContacts: [MobileContact] = []
        
        contacts.forEach { contact in
            mappedContacts.append(contentsOf: map(contact: contact))
        }
        
        return mappedContacts
    }
    
    public func map(contact: CNContact) -> [MobileContact] {
        let phoneNumbers = contact.phoneNumbers.map { number -> String in
            return number.value.stringValue
        }
        
        var contacts: [MobileContact] = []
        
        phoneNumbers.forEach { number in
            contacts.append(MobileContact(fullName: fullName(contact: contact), phoneNumber: number))
        }
        
        return contacts
    }
}

private extension ContactMapper {
    func fullName(contact: CNContact) -> String {
        if let personName = personName(contact: contact) {
            return personName
        } else if !contact.organizationName.isEmpty {
            return contact.organizationName
        } else {
            return ""
        }
    }
    
    func personName(contact: CNContact) -> String? {
        if contact.givenName.isEmpty && contact.familyName.isEmpty {
            return nil
        } else if contact.givenName.isEmpty {
            return contact.familyName
        } else if contact.familyName.isEmpty {
            return contact.givenName
        }
        let fullNameElements = [contact.givenName, contact.familyName]
        let fullName = fullNameElements.joined(separator: " ")
        return fullName
    }
}

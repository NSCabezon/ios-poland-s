import Contacts

protocol ContactMapping {
    func map(contacts: [CNContact]) -> [Contact]
}

final class ContactMapper: ContactMapping {
    
    func map(contacts: [CNContact]) -> [Contact] {
        var mappedContacts: [Contact] = []
        
        contacts.forEach { contact in
            mappedContacts.append(contentsOf: map(contact: contact))
        }
        
        return mappedContacts
    }
    
    func map(contact: CNContact) -> [Contact] {
        let phoneNumbers = contact.phoneNumbers.map { number -> String in
            return number.value.stringValue
        }
        
        var contacts: [Contact] = []
        
        phoneNumbers.forEach { number in
            contacts.append(Contact(fullName: fullName(contact: contact), phoneNumber: number))
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

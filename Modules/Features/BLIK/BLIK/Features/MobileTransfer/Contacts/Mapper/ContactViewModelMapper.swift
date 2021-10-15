import Foundation

protocol ContactViewModelMapping {
    func map(contacts: [Contact]) -> [ContactViewModel]
}

final class ContactViewModelMapper: ContactViewModelMapping {
    private let emptyNameSign = "#"
    
    func map(contacts: [Contact]) -> [ContactViewModel] {
        let viewModels = Dictionary(grouping: contacts) { contact -> String in
            return String(contact.fullName.first ?? Character(emptyNameSign))
        }
        .map { (key: String, value: [Contact]) -> (letter: String, contacts: [Contact]) in
            (letter: key, contacts: value)
        }
        .sorted { left, right in
            left.letter.compare(right.letter, locale: Locale(identifier: "pl_PL")) == .orderedAscending
        }
        .map { ContactViewModel(letter: $0.letter, contacts: $0.contacts) }
        
        let filteredViewModel = viewModels.filter {$0.letter == emptyNameSign}
        if filteredViewModel.isEmpty {
            return viewModels
        } else {
            var letterViewModels = viewModels.filter { $0.letter != emptyNameSign}
            letterViewModels.append(contentsOf: filteredViewModel)
            
            return letterViewModels
        }
    }
}

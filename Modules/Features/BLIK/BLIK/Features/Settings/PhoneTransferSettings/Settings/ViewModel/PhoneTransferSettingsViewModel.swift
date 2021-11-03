//
//  PhoneTransferSettingsViewModel.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 22/07/2021.
//

enum PhoneTransferSettingsViewModel {
    case unregisteredPhoneNumber
    case registeredPhoneNumber
    case expiredPhoneNumber
    
    var title: String {
        return "#Przelew na telefon"
    }
    
    var userMessage: String {
        switch self {
        case .unregisteredPhoneNumber, .registeredPhoneNumber:
            return "#Przelew na telefon to przelew, do którego wysłania nie jest konieczne podanie numeru konta. Wystarczy numer telefonu. Przelew jest bezpłatny. Pieniądze natychmiast trafiają na konto odbiorcy.\n\nAby otrzymać pieniądze odbiorca musi zarejestrować swój numer telefonu w bazie powiązań BLIK."
        case .expiredPhoneNumber:
            return "#Z powodu zmiany numeru telefonu służącego do przesyłania smsKodów konieczna jest aktualizacja numeru telefonu do otrzymywania Przelewów na telefon."
        }
    }
    
    var icon: UIImage {
        return Images.info
    }
}

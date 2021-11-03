//
//  PhoneTransferRegistrationFormViewModelMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 16/08/2021.
//

import PLCommons

protocol PhoneTransferRegistrationFormViewModelMapping {
    func map(_ account: BlikCustomerAccount) -> PhoneTransferRegistrationFormViewModel
}

final class PhoneTransferRegistrationFormViewModelMapper: PhoneTransferRegistrationFormViewModelMapping {
    private let amountFormatter: NumberFormatter
    
    init(amountFormatter: NumberFormatter) {
        self.amountFormatter = amountFormatter
    }
    
    func map(_ account: BlikCustomerAccount) -> PhoneTransferRegistrationFormViewModel {
        amountFormatter.currencySymbol = account.availableFunds.currency
        return getViewModel(
            accountNumber: account.number,
            accountName: account.name,
            availableFunds: getAvailableFundsText(
                forAmount: account.availableFunds.amount,
                currency: account.availableFunds.currency
            )
        )
    }
    
    private func getViewModel(
        accountNumber: String,
        accountName: String,
        availableFunds: String
    ) -> PhoneTransferRegistrationFormViewModel {
        let hintMessage = "#Aby otrzymywać przelew od innych osób, zarejestruj się w bazie powiązań BLIK. Rejestracja zajmie tylko chwilę."
        
        let accountViewTitle = "#Na ten rachunek otrzymasz pieniądze"
        
        let phoneViewTitle = "#Numer telefonu"
        let phoneViewNumber = "#Taki sam jak numer do smsKodów"
        
        let statementTitle = "#Oświadczenie"
        let statementDescription = """
    #Składam dyspozycję otrzymywania na wskazany rachunek bankowy \(accountNumber) Przelewów na telefon BLIK wysyłanych na numer telefonu komórkowego służący, zgodnie z obowiązującą „Umowa usług Santander online dla klientów indywidualnych”, do przesyłania mi przez Santander Bank Polska S.A. smsKodów.
        
    Moja dyspozycja uchyla ewentualne wcześniej złożone przeze mnie w Santander S.A. lub innych bankach dyspozycje dotyczące otrzymywania Przelewów na telefon BLIK wysyłanych na wskazany numer telefonu komórkowego.
    Przyjmuję do wiadomości, że w przypadku zmiany numeru telefonu komórkowego do przesyłania smsKodów lub wskazanego numeru rachunku w celu dalszego otrzymywania Przelewów na telefon BLIK muszę ponownie złożyć odpowiednią dyspozycję.
    """
        
        return PhoneTransferRegistrationFormViewModel(
            hintMessage: hintMessage,
            accountViewModel: .init(
                title: accountViewTitle,
                accountName: accountName,
                availableFunds: availableFunds,
                accountNumber: accountNumber
            ),
            phoneViewModel: .init(
                title: phoneViewTitle,
                phoneNumber: phoneViewNumber
            ),
            statementViewModel: .init(
                title: statementTitle,
                description: statementDescription)
        )
    }
    
    private func getAvailableFundsText(
        forAmount amount: Decimal,
        currency: String
    ) -> String {
        return amountFormatter.string(for: amount) ?? "\(amount) \(currency)"
    }
}

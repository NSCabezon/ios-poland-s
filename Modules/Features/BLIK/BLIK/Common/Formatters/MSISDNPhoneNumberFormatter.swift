import Foundation

final class MSISDNPhoneNumberFormatter {
    private let allowedCharacterSet = CharacterSet.decimalDigits.inverted
    
    func format(phoneNumber: String) -> String {
        return phoneNumber.components(separatedBy: allowedCharacterSet).joined()
    }
    
    // Phone numbers that are fetched from iOS contacts book can have different formats
    // They don't always contain country code which is required in blik availability check endpoint
    //
    // Blik uses polish phone numbers, hence we duplicate numbers that contain 9 digits and append `48` country code prefix to them
    // Thanks to this workaround most of users' contacts will work properly (many users have their contacts saved without `48` prefix)
    //
    // In worst case scenario foreign phone numbers won't work properly (e.g. swedish -> 7 digit number + 2 digit country code = 9 digits)
    // That's something that we're aware of
    //
    func polishCountryCodeAppendedNumbers(formattedNumbers: [FormattedNumberMetadata]) -> [FormattedNumberMetadata] {
        var numbers = formattedNumbers
        formattedNumbers.enumerated().forEach { (offset, number) in
            guard let polishFormatNumber = polishCountryCodeAppendedNumber(formattedNumber: number) else { return }
            numbers[offset] = polishFormatNumber
        }
        return numbers
    }
    
    func polishCountryCodeAppendedNumber(formattedNumber: FormattedNumberMetadata) -> FormattedNumberMetadata? {
        let trimmedNumber = formattedNumber.formattedNumber.replacingOccurrences(of: "^0+",
                                                                        with: "",
                                                                        options: .regularExpression)
        if trimmedNumber.count == 11 && trimmedNumber.hasPrefix("48") {
            return FormattedNumberMetadata(formattedNumber: trimmedNumber,
                                           unformattedNumber: formattedNumber.unformattedNumber)
        }
        let couldBePolishNumberWithoutCountryCode = trimmedNumber.count == 9
        guard couldBePolishNumberWithoutCountryCode else {
            return nil
        }
        
        let polishFormatNumber = FormattedNumberMetadata(formattedNumber: "48" + trimmedNumber,
                                                         unformattedNumber: formattedNumber.unformattedNumber)
        return polishFormatNumber
    }
}

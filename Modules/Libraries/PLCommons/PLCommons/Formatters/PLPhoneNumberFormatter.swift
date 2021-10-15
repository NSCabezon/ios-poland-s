import UI

public class PLPhoneNumberTextFieldFormatter: NSObject, TextFieldFormatter {
    
    private lazy var formatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = false
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        formatter.maximumIntegerDigits = 13
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.groupingSize = 3
        formatter.roundingMode = .down
        formatter.locale = Locale(identifier: "pl")
        return formatter
    }()
    
    public var delegate: UITextFieldDelegate?
    public var customDelegate: ChangeTextFieldDelegate?

    private func correctCaret(in textField: UITextField, string: String, range: NSRange) -> UITextRange? {
        let isErasing = string.isEmpty && range.length > 0
        let currentCaretPosition = isErasing ? range.location : range.location + string.count - range.length
        
        if let newCaretPosition = textField.position(from: textField.beginningOfDocument, offset: currentCaretPosition) {
            return textField.textRange(from: newCaretPosition, to: newCaretPosition)
        }
        return nil
    }
    
    private func filter(text: String, characterSet: CharacterSet) -> String {
        guard !text.isEmpty else {
            return text
        }
        let validCharacterText = text.filterValidCharacters(characterSet: characterSet)
        return validCharacterText
    }
    
    private func isValidInsertion(text: String, insertedString: String, insertionPosition: Int) -> Bool? {
        if text.filter({ $0 != " "}).lengthOfBytes(using: .utf8) >= formatter.maximumIntegerDigits {
            return false
        }
        
        return nil
    }
    
    public func formatStrnig(numberInString: String) -> String {
        guard let decimalValue = Decimal(string: numberInString.replacingOccurrences(of: " ", with: "")), let formattedText = formatter.string(from: NSDecimalNumber(decimal: decimalValue)) else {
            return ""
        }
        return formattedText
    }
}

extension PLPhoneNumberTextFieldFormatter: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        defer {
            textField.sendActions(for: .editingChanged)
        }
        
        guard let oldText = textField.text else {
            return false
        }
        
        let validCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: " "))
        
        if string != "", let value = isValidInsertion(text: oldText, insertedString: string, insertionPosition: range.location) {
            return value
        }
        
        guard let convertedRange = Range(range, in: oldText) else {
            return false
        }
        
        var newText = oldText.replacingCharacters(in: convertedRange, with: string)
        newText = newText.replacingOccurrences(of: " ", with: "")
        newText = filter(text: newText, characterSet: validCharacters)
        
        var separatorsToSelectionOld = 0
        var originalPosition = 0
        originalPosition = range.location
        let oldTextPrefixed = String(oldText.prefix(originalPosition))
        separatorsToSelectionOld = oldTextPrefixed.filter({$0 == " "}).count
        
        if newText == "" {
            if string == "" {
                customDelegate?.willChangeText(textField: textField, text: newText)
                return true
            } else {
                textField.selectedTextRange = correctCaret(in: textField, string: oldText, range: range)
                return false
            }
        }
        guard let decimalValue = Decimal(string: newText), var formattedText = formatter.string(from: NSDecimalNumber(decimal: decimalValue)) else {
            return false
        }
    
        if newText.count > formattedText.replacingOccurrences(of: " ", with: "").count {
            if let firstNoZeroIndex = newText.firstIndex(where: { character in
                return character != "0"
            }) {
                let substring = newText.prefix(upTo: firstNoZeroIndex)
                formattedText = substring + formattedText
            } else {
                formattedText = "0" + formattedText
            }
        }
        customDelegate?.willChangeText(textField: textField, text: newText)
        textField.text = formattedText
        
        let separatorsToOriginalPositionNew = formattedText.prefix(originalPosition).filter({ $0 == " " }).count
        let newSubstring = formattedText.prefix(originalPosition + string.count - (separatorsToSelectionOld - separatorsToOriginalPositionNew))
        
        let separatorsToSelectionNew = newSubstring.filter({ $0 == " "}).count
        let separatorAdjustment = separatorsToSelectionNew - separatorsToSelectionOld
        
        if let newCaretPosition = textField.position(from: textField.beginningOfDocument, offset: originalPosition + separatorAdjustment + string.count) {
            textField.selectedTextRange = textField.textRange(from: newCaretPosition, to: newCaretPosition)
        }
        
        return false
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField)
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn?(textField) ?? false
    }
    
}

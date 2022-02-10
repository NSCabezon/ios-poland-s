import UI
import CoreFoundationLib

final public class PLAccountTextFieldFormatter: NSObject, TextFieldFormatter {
    weak public var delegate: UITextFieldDelegate?
    weak public var customDelegate: ChangeTextFieldDelegate?
    private var maxLength: Int
    private var allowOnlyCharacterSet: CharacterSet

    public init(
        maxLength: Int = 26,
        allowOnlyCharacterSet: CharacterSet = CharacterSet.numbers
    ) {
        self.maxLength = maxLength
        self.allowOnlyCharacterSet = allowOnlyCharacterSet
    }
    
    public func setMaxLength(_ maxLength: Int) {
        self.maxLength = maxLength
    }
    
    public func setAllowOnlyCharacters(_ characterSet: CharacterSet) {
        self.allowOnlyCharacterSet = characterSet
    }
    
    func filter(text: String) -> String {
        guard !text.isEmpty else {
            return text
        }
        let text = text.trimmingCharacters(in: .numbers.inverted)
        let validCharacterText = text.filterValidCharacters(characterSet: allowOnlyCharacterSet)
        let validText = filterMaxSize(text: validCharacterText)
        return validText
    }
    
    func filterMaxSize(text: String) -> String {
        guard let textFiltered = text.substring(0, min(maxLength, text.count)) else {
            return text
        }
        return textFiltered
    }
}

extension PLAccountTextFieldFormatter: UITextFieldDelegate {
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        defer {
            textField.sendActions(for: .editingChanged)
        }
        let oldText = textField.text ?? ""
        guard let convertedRange = Range(range, in: oldText) else {
            return false
        }
        let currentText = oldText.replacingCharacters(
            in: convertedRange,
            with: string
        )
        let currentTextFiltered = filter(text: currentText)
        textField.text = format(for: currentTextFiltered)
        customDelegate?.willChangeText(
            textField: textField,
            text: currentTextFiltered
        )
        if string.isEmpty && range.location > 0 {
            setCorrectCaret(in: textField, newCurrentLocation: range.location)
        } else {
            var currentCaretPosition = range.location
            let index = oldText.index(oldText.startIndex, offsetBy: currentCaretPosition)
            if index == oldText.endIndex || oldText[index] == " " {
                currentCaretPosition += 1
            }
            let modifiedCurrentCaretPosition = currentCaretPosition + string.count
            setCorrectCaret(in: textField, newCurrentLocation: modifiedCurrentCaretPosition)
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

private extension PLAccountTextFieldFormatter {
    func format(for text: String) -> String {
        guard let controlDigits = text.substring(0, 2), !controlDigits.isEmpty,
              let accountNumber = text.substring(2, text.count), !accountNumber.isEmpty else {
            return text
        }
        let splits = accountNumber.split(byLength: 4)
        guard splits.count > 0 else {
            return text
        }
        let formatText = controlDigits + " " + splits[1..<splits.count].reduce("\(splits[0])", {"\($0) \($1)"})
        return formatText
    }
    
    private func setCorrectCaret(in textField: UITextField, newCurrentLocation: Int) {
        guard let newCaretPosition = textField.position(
                from: textField.beginningOfDocument,
                offset: newCurrentLocation
        ) else { return }
        textField.selectedTextRange = textField.textRange(
            from: newCaretPosition,
            to: newCaretPosition
        )
    }
}

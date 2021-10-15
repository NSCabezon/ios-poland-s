//
//  PLAmountTextFieldFormatter.swift
//  PLUI
//
//  Created by Piotr Mielcarzewicz on 19/07/2021.
//

import UI

public class PLAmountTextFieldFormatter: NSObject, TextFieldFormatter {
    private var maximumFractionDigits: Int {
        didSet {
            formatter.maximumFractionDigits = maximumFractionDigits
        }
    }
    private var maximumIntegerDigits: Int {
        didSet {
            formatter.maximumIntegerDigits = maximumIntegerDigits
        }
    }
    private var usesGroupingSeparator: Bool {
        didSet {
            formatter.usesGroupingSeparator = usesGroupingSeparator
        }
    }
    
    private lazy var formatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = false
        formatter.usesGroupingSeparator = usesGroupingSeparator
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.maximumIntegerDigits = maximumIntegerDigits
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.groupingSize = 3
        formatter.roundingMode = .down
        formatter.locale = Locale(identifier: "en")
        return formatter
    }()

    weak public var delegate: UITextFieldDelegate?
    weak public var customDelegate: ChangeTextFieldDelegate?
    
    public init(maximumIntegerDigits: Int = 12, maximumFractionDigits: Int = 2, usesGroupingSeparator: Bool = true) {
        self.maximumIntegerDigits = maximumIntegerDigits
        self.maximumFractionDigits = maximumFractionDigits
        self.usesGroupingSeparator = usesGroupingSeparator
        super.init()
    }
    
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
        if let fractionPosition = text.firstIndex(of: ",")?.encodedOffset {
            //Check decimal lenght
            if insertionPosition > fractionPosition {
                //check fraction
                if (text.lengthOfBytes(using: .utf8) - fractionPosition) > maximumFractionDigits {
                    return false
                }
            } else if text.prefix(fractionPosition).filter({ $0 != " "}).lengthOfBytes(using: .utf8) >= maximumIntegerDigits {
                return false
            }
        } else if text.filter({ $0 != " "}).lengthOfBytes(using: .utf8) >= maximumIntegerDigits && insertedString != "," {
            return false
        }
        
        return nil
    }
    
}

extension PLAmountTextFieldFormatter: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        defer {
            textField.sendActions(for: .editingChanged)
        }
        guard let oldText = textField.text else {
            return false
        }
        
        let inputString = string.replacingOccurrences(of: ".", with: ",")
        
        guard !(maximumFractionDigits == 0 && inputString == ",") else {
            return false
        }
        
        let validCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ", "))
        
        if textField.text?.contains(",") == true && (inputString.contains(",") || inputString.contains(" ")) {
            return false
        }
        
        if inputString != "", let value = isValidInsertion(text: oldText, insertedString: inputString, insertionPosition: range.location) {
            return value
        }
        
        guard let convertedRange = Range(range, in: oldText) else {
            return false
        }
        var newText = oldText.replacingCharacters(in: convertedRange, with: inputString)
        newText = newText.replacingOccurrences(of: " ", with: "")
        newText = newText.replacingOccurrences(of: ",", with: " ")
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
        
        if newText.hasPrefix(" ") {
            newText = "0" + newText
            originalPosition += 1
        }
        
        formatter.alwaysShowsDecimalSeparator = newText.contains(" ") && maximumFractionDigits > 0
        if newText.contains(" "), let startIndex = newText.firstIndex(of: " ") {
            let decimalsDigits = newText[startIndex...].count - 1
            formatter.minimumFractionDigits = min(decimalsDigits, maximumFractionDigits)
        } else {
            formatter.minimumFractionDigits = 0
        }
        newText = newText.replacingOccurrences(of: " ", with: ".")
        guard let decimalValue = Decimal(string: newText), let formattedText = formatter.string(from: NSDecimalNumber(decimal: decimalValue)) else {
            return false
        }
        
        customDelegate?.willChangeText(textField: textField, text: newText)
        textField.text = formattedText

        let separatorsToOriginalPositionNew = formattedText.prefix(originalPosition).filter({ $0 == " " }).count
        let newSubstring = formattedText.prefix(originalPosition + inputString.count - (separatorsToSelectionOld - separatorsToOriginalPositionNew))
        
        let separatorsToSelectionNew = newSubstring.filter({ $0 == " "}).count
        let separatorAdjustment = separatorsToSelectionNew - separatorsToSelectionOld
        
        if let newCaretPosition = textField.position(from: textField.beginningOfDocument, offset: originalPosition + separatorAdjustment + inputString.count) {
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

extension UIAmountTextFieldFormatter {
    public func formatAmount (fromString string: String?) -> Decimal? {
        guard let optionalString = string else {
            return nil
        }
        let decimalValue = String(optionalString)
        return decimalValue.stringToDecimal
    }
}

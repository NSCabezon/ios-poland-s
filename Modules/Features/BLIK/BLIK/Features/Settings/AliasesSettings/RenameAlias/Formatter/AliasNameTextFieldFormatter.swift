//
//  AliasNameTextFieldFormatter.swift
//  BLIK
//
//  Created by 187830 on 22/11/2021.
//

import CoreFoundationLib
import UI
import PLUI

final class AliasNameTextFieldFormatter: NSObject, TextFieldFormatter {
   
    weak var delegate: UITextFieldDelegate?
    weak var customDelegate: ChangeTextFieldDelegate?
    private var maxLength: Int
    private var allowOnlyCharacterSet: CharacterSet
    
    init(
        maxLength: Int = 255,
        allowOnlyCharacterSet: CharacterSet = CharacterSet.operative
    ) {
        self.allowOnlyCharacterSet = allowOnlyCharacterSet
        self.maxLength = maxLength
    }
    
    func setMaxLength(maxLength: Int) {
        self.maxLength = maxLength
    }

    func setAllowOnlyCharacters(_ characterSet: CharacterSet) {
        self.allowOnlyCharacterSet = characterSet
    }

    func filter(text: String) -> String {
        guard !text.isEmpty else {
            return text
        }
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

extension AliasNameTextFieldFormatter: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && string == " " {
            return false
        }
        
        let oldText = textField.text ?? ""
        guard let convertedRange = Range(range, in: oldText) else {
            return false
        }
        let currentText = oldText.replacingCharacters(
            in: convertedRange,
            with: string
        )
        let textFiltered = filter(text: currentText)
        customDelegate?.willChangeText(
            textField: textField,
            text: textFiltered
        )
        var exit = true
        
        let character = CharacterSet(charactersIn: string)
        exit = allowOnlyCharacterSet.isSuperset(of: character)

        if textFiltered != currentText {
            let count = textField.text?.count ?? 0
            let notIsInsertAtEnd = range.length != 0 || count != range.location
            textField.text = textFiltered
            
            if notIsInsertAtEnd, let newCaretPosition = textField.position(from: textField.beginningOfDocument, offset: range.location + string.count) {
                textField.selectedTextRange = textField.textRange(from: newCaretPosition, to: newCaretPosition)
            }
            exit = false
        }
        
        return exit
    }
}


//
//  ViewController+SMSAuthenticationView.swift
//  PLUI_Example
//
//  Created by Marcos Álvarez Mesa on 25/5/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import PLUI

extension ViewController {

    private enum InputCodeViewConstants {
        static let smsCharactersSet: CharacterSet = .decimalDigits
        static let passwordCharactersSet: CharacterSet = .alphanumerics
    }

    func smsAuthenticationView() -> SMSInputCodeView {

        let maskedPasswordView = SMSInputCodeView(delegate: self)
        return maskedPasswordView
    }

    func maskedPasswordView() -> MaskedPasswordInputCodeView {

        let requestedPositions: [NSInteger] = [1, 3, 5, 8, 14, 16, 19, 20]

        let maskedPasswordView = MaskedPasswordInputCodeView(requestedPositions: requestedPositions,
                                                    delegate: self)
        return maskedPasswordView
    }
}


extension ViewController: InputCodeViewDelegate {

    func codeView(_ view: InputCodeView, didChange string: String, for position: NSInteger) {

        let type = String(describing: type(of: view))
        print("\(type) Text introduced: \(string) Position: \(position)")
    }

    func codeView(_ view: InputCodeView, willChange string: String, for position: NSInteger) -> Bool {

        var characterSet: CharacterSet
        switch view.self {
        case is MaskedPasswordInputCodeView:
            characterSet = InputCodeViewConstants.passwordCharactersSet
        case is SMSInputCodeView:
            characterSet = InputCodeViewConstants.smsCharactersSet
        default:
            characterSet = .alphanumerics
        }

        guard string.count == 1,
              let character = UnicodeScalar(string),
              characterSet.contains(UnicodeScalar(character)) == true else {
            return false
        }
        return true
    }

    func codeView(_ view: InputCodeView, didBeginEditing position: NSInteger) {}

    func codeView(_ view: InputCodeView, didEndEditing position: NSInteger) {}

    func codeView(_ view: InputCodeView, didDelete position: NSInteger) {}
}


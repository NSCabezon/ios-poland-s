//
//  ViewController+InputCodeViewDelegate.swift
//  PLUI_Example
//
//  Created by Marcos Álvarez Mesa on 25/5/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import PLUI

extension ViewController {

    private enum InputCodeViewConstants {
        enum SMS {
            static let charactersSet: CharacterSet = .decimalDigits
            static let keyboardType: UIKeyboardType = .numberPad
            static let boxSize = CGSize(width: 39.0, height: 56.0)
        }
        enum MaskedPassword {
            static let charactersSet: CharacterSet = .alphanumerics
            static let keyboardType: UIKeyboardType = .default
            static let boxSize = CGSize(width: 31.0, height: 56.0)
        }
    }

    func smsAuthenticationView() -> PLUIInputCodeView {

        let smsAuthenticationView = PLUIInputCodeView(keyboardType: InputCodeViewConstants.SMS.keyboardType,
                                                      delegate: self,
                                                      facade: PLUIInputCodeSMSFacade(),
                                                      elementSize: InputCodeViewConstants.SMS.boxSize,
                                                      requestedPositions: .all,
                                                      charactersSet: InputCodeViewConstants.SMS.charactersSet)
        return smsAuthenticationView
    }

    func maskedPasswordView() -> PLUIInputCodeView {

        let requestedPositions: [NSInteger] = [1, 3, 5, 8, 14, 16, 19, 20]

        let maskedPasswordView = PLUIInputCodeView(keyboardType: InputCodeViewConstants.MaskedPassword.keyboardType,
                                                   delegate: self,
                                                   facade: PLUIInputCodeMaskedPasswordFacade(),
                                                   elementSize: InputCodeViewConstants.MaskedPassword.boxSize,
                                                   requestedPositions: RequestedPositions.positions(requestedPositions),
                                                   charactersSet: InputCodeViewConstants.MaskedPassword.charactersSet)
        return maskedPasswordView
    }
}


extension ViewController: PLUIInputCodeViewDelegate {

    func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger) {

        let type = String(describing: type(of: view))
        print("\(type) Text: \(string) Position: \(position)")
    }

    func codeView(_ view: PLUIInputCodeView, willChange string: String, for position: NSInteger) -> Bool {

        guard string.count == 1,
              let character = UnicodeScalar(string),
              view.charactersSet.contains(UnicodeScalar(character)) == true else {
            return false
        }
        return true
    }

    func codeView(_ view: PLUIInputCodeView, didBeginEditing position: NSInteger) {}

    func codeView(_ view: PLUIInputCodeView, didEndEditing position: NSInteger) {}

    func codeView(_ view: PLUIInputCodeView, didDelete position: NSInteger) {}
}


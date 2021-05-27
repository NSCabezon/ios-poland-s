//
//  ViewController+MaskedPasswordViewDelegate.swift
//  PLUI_Example
//
//  Created by Marcos Álvarez Mesa on 24/5/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//
import PLUI

extension ViewController {

    private enum MaskedPasswordConstants {
        static let acceptedCharactersSet: CharacterSet = .alphanumerics
    }

    func maskedPasswordView() -> MaskedPasswordView {

        let requestedPositions: [NSInteger] = [1, 3, 5, 8, 14, 16, 19, 20]

        let maskedPasswordView = MaskedPasswordView(requestedPositions: requestedPositions,
                                                    keyboardType: .default,
                                                    showPositions: true,
                                                    delegate: self)
        maskedPasswordView.backgroundColor = .black

        return maskedPasswordView
    }

    
}

extension ViewController: MaskedPasswordViewDelegate {

    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, didChange string: String, for position: NSInteger) {

        print("Text introduced: \(string) Position: \(position)")
    }

    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, willChange string: String, for position: NSInteger) -> Bool {

        guard string.count == 1,
              let character = UnicodeScalar(string),
              MaskedPasswordConstants.acceptedCharactersSet.contains(UnicodeScalar(character)) == true else {
            return false
        }
        return true
    }

    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, didBeginEditing position: NSInteger) {}

    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, didEndEditing position: NSInteger) {}

    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, didDelete position: NSInteger) {}
}

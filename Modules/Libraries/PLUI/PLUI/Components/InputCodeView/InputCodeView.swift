//
//  CodeView.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 26/5/21.
//

import Foundation

public protocol InputCodeViewDelegate: AnyObject {
    func codeView(_ view: InputCodeView, didChange string: String, for position: NSInteger)
    func codeView(_ view: InputCodeView, willChange string: String, for position: NSInteger) -> Bool
    func codeView(_ view: InputCodeView, didBeginEditing position: NSInteger)
    func codeView(_ view: InputCodeView, didEndEditing position: NSInteger)
    func codeView(_ view: InputCodeView, didDelete position: NSInteger)
}

public class InputCodeView: UIView {

    var inputBoxArray = [InputCodeBoxView]()
    private weak var delegate: InputCodeViewDelegate?
    private var keyboardType: UIKeyboardType

    /**
     - Parameters:
     - Parameter delegate: delegate
     - Parameter keyboardType: keyboard that will be shown when user select any of the enabled inputCodeBoxView
     */
    init(keyboardType: UIKeyboardType = .default,
         delegate: InputCodeViewDelegate?) {

        self.keyboardType = keyboardType
        self.delegate = delegate
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult override public func resignFirstResponder() -> Bool {
        self.inputBoxArray.isAnyFirstResponder()?.resignFirstResponder()
        return true
    }
}

extension InputCodeView: InputCodeBoxViewDelegate {

    func codeBoxViewShouldChangeString (_ codeBoxView: InputCodeBoxView, replacementString string: String) -> Bool {
        let allowChange = self.delegate?.codeView(self, willChange: string, for: codeBoxView.position)

        guard allowChange == true else {
            codeBoxView.text = ""
            return false
        }

        codeBoxView.text = string

        if let nextPasswordInputBoxView = self.inputBoxArray.nextEnabled(from: codeBoxView.position) {
            nextPasswordInputBoxView.becomeFirstResponder()
        } else {
            codeBoxView.resignFirstResponder()
        }

        self.delegate?.codeView(self, didChange: string, for: codeBoxView.position)

        return true
    }

    func codeBoxViewDidBeginEditing (_ codeBoxView: InputCodeBoxView) {
        codeBoxView.setKeyboardType(self.keyboardType)
        self.delegate?.codeView(self, didBeginEditing: codeBoxView.position)
    }

    func codeBoxViewDidEndEditing (_ codeBoxView: InputCodeBoxView) {
        self.delegate?.codeView(self, didEndEditing: codeBoxView.position)
    }

    func codeBoxViewDidDelete (_ codeBoxView: InputCodeBoxView) {
        self.delegate?.codeView(self, didDelete: codeBoxView.position)
    }
}

extension Array where Element == InputCodeBoxView {

    func nextEnabled(from position: NSInteger) -> InputCodeBoxView? {
        guard position < self.count else { return nil }
        let next = self.first { $0.enabled == true && $0.position > position }
        return next
    }

    func isAnyFirstResponder() -> InputCodeBoxView? {
        for passwordInputBoxView in self {
            if passwordInputBoxView.isFirstResponder {
                return passwordInputBoxView
            }
        }
        return nil
    }
}

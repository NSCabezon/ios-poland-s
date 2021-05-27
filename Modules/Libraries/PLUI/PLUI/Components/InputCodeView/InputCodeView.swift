//
//  InputCodeView.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 26/5/21.
//

public protocol InputCodeViewDelegate: AnyObject {
    func codeView(_ view: InputCodeView, didChange string: String, for position: NSInteger)
    func codeView(_ view: InputCodeView, willChange string: String, for position: NSInteger) -> Bool
    func codeView(_ view: InputCodeView, didBeginEditing position: NSInteger)
    func codeView(_ view: InputCodeView, didEndEditing position: NSInteger)
    func codeView(_ view: InputCodeView, didDelete position: NSInteger)
}

public protocol InputCodeFacade: AnyObject {
    func view(with boxes: [InputCodeBoxView]) -> UIView
    func configuration() -> InputCodeFacadeConfiguration
//    func shouldShowPositions() -> Bool
//    func shouldShowSecureEntry() -> Bool
//    func elementsNumber() -> NSInteger
}

public struct InputCodeFacadeConfiguration {
    let showPositions: Bool
    let showSecureEntry: Bool
    let elementsNumber: NSInteger
}

public enum RequestedPositions {
    case all
    case positions([NSInteger])

    func isRequestedPosition(position: NSInteger) -> Bool {
        switch self {
        case .all:
            return true
        case .positions(let positions):
            return positions.contains(where: { $0 == position })
        }
    }
}

public class InputCodeView: UIView {

    var inputCodeBoxArray = [InputCodeBoxView]()
    public let charactersSet: CharacterSet
    private weak var delegate: InputCodeViewDelegate?
    private var keyboardType: UIKeyboardType
    private let facade: InputCodeFacade

    /**
     - Parameters:
     - Parameter keyboardType: keyboard that will be shown when user select any of the requested inputCodeBoxView
     - Parameter delegate: delegate
     - Parameter facade: Facade used por drawing the InputCodeView
     - Parameter elementSize: size for the element to be drawn
     - Parameter requestedPositions: positions requested for user to write (From 1 to elementsNumber)
     - Parameter charactersSet: characterSet used for validating the user´s entry
     */
    public init(keyboardType: UIKeyboardType = .default,
         delegate: InputCodeViewDelegate?,
         facade: InputCodeFacade,
         elementSize: CGSize,
         requestedPositions: RequestedPositions,
         charactersSet: CharacterSet) {

        self.facade = facade
        self.keyboardType = keyboardType
        self.delegate = delegate
        self.charactersSet = charactersSet
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false

        let facadeConfiguration = self.facade.configuration()
        for position in 1...facadeConfiguration.elementsNumber {
            self.inputCodeBoxArray.append(InputCodeBoxView(position: position,
                                                       showPosition: facadeConfiguration.showPositions,
                                                       delegate: self,
                                                       requested: requestedPositions.isRequestedPosition(position: position),
                                                       isSecureEntry: facadeConfiguration.showSecureEntry,
                                                       size: elementSize))
        }

        self.addSubviews(view: self.facade.view(with: self.inputCodeBoxArray))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult override public func resignFirstResponder() -> Bool {
        self.inputCodeBoxArray.isAnyFirstResponder()?.resignFirstResponder()
        return true
    }
}

private extension InputCodeView {

    func addSubviews(view: UIView) {
        self.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
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

        if let nextPasswordInputBoxView = self.inputCodeBoxArray.nextEnabled(from: codeBoxView.position) {
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
        let next = self.first { $0.requested == true && $0.position > position }
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

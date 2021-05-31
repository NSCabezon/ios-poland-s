//
//  PLUIInputCodeView.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 26/5/21.
//

public protocol PLUIInputCodeViewDelegate: AnyObject {
    func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger)
    func codeView(_ view: PLUIInputCodeView, willChange string: String, for position: NSInteger) -> Bool
    func codeView(_ view: PLUIInputCodeView, didBeginEditing position: NSInteger)
    func codeView(_ view: PLUIInputCodeView, didEndEditing position: NSInteger)
    func codeView(_ view: PLUIInputCodeView, didDelete position: NSInteger)
}

public protocol PLUIInputCodeFacade: AnyObject {
    func view(with boxes: [PLUIInputCodeBoxView]) -> UIView
    func configuration() -> PLUIInputCodeFacadeConfiguration
}

public struct PLUIInputCodeFacadeConfiguration {
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

public class PLUIInputCodeView: UIView {

    var inputCodeBoxArray = [PLUIInputCodeBoxView]()
    public let charactersSet: CharacterSet
    private weak var delegate: PLUIInputCodeViewDelegate?
    private var keyboardType: UIKeyboardType
    private let facade: PLUIInputCodeFacade

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
         delegate: PLUIInputCodeViewDelegate?,
         facade: PLUIInputCodeFacade,
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
            self.inputCodeBoxArray.append(PLUIInputCodeBoxView(position: position,
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

private extension PLUIInputCodeView {

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

extension PLUIInputCodeView: PLUIInputCodeBoxViewDelegate {

    func codeBoxViewShouldChangeString (_ codeBoxView: PLUIInputCodeBoxView, replacementString string: String) -> Bool {
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

    func codeBoxViewDidBeginEditing (_ codeBoxView: PLUIInputCodeBoxView) {
        codeBoxView.setKeyboardType(self.keyboardType)
        self.delegate?.codeView(self, didBeginEditing: codeBoxView.position)
    }

    func codeBoxViewDidEndEditing (_ codeBoxView: PLUIInputCodeBoxView) {
        self.delegate?.codeView(self, didEndEditing: codeBoxView.position)
    }

    func codeBoxViewDidDelete (_ codeBoxView: PLUIInputCodeBoxView) {
        self.delegate?.codeView(self, didDelete: codeBoxView.position)
    }
}

extension Array where Element == PLUIInputCodeBoxView {

    func nextEnabled(from position: NSInteger) -> PLUIInputCodeBoxView? {
        guard position < self.count else { return nil }
        let next = self.first { $0.requested == true && $0.position > position }
        return next
    }

    func isAnyFirstResponder() -> PLUIInputCodeBoxView? {
        for passwordInputBoxView in self {
            if passwordInputBoxView.isFirstResponder {
                return passwordInputBoxView
            }
        }
        return nil
    }
}

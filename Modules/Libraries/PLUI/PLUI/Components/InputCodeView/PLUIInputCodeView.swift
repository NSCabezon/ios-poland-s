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

    private enum AccesibilityIdentifiers {
        static let container = "CodeItemsContainer"
    }

    private var inputCodeBoxArray = [PLUIInputCodeBoxView]()
    public let charactersSet: CharacterSet
    private weak var delegate: PLUIInputCodeViewDelegate?
    private var keyboardType: UIKeyboardType
    private let facade: PLUIInputCodeFacadeProtocol

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
                facade: PLUIInputCodeFacadeProtocol,
                elementSize: CGSize,
                requestedPositions: RequestedPositions,
                charactersSet: CharacterSet) {
        self.facade = facade
        self.keyboardType = keyboardType
        self.delegate = delegate
        self.charactersSet = charactersSet
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureInputCodeBoxArray(facade: facade,
                                        elementSize: elementSize,
                                        requestedPositions: requestedPositions)
        self.addSubviews(view: self.facade.view(with: self.inputCodeBoxArray))
        self.configureAccessibilityIdentifiers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult override public func resignFirstResponder() -> Bool {
        self.inputCodeBoxArray.isAnyFirstResponder()?.resignFirstResponder()
        return true
    }

    /**
     Returns the position of the first element that is required and empty, in other case returns nil
     */
    public func firstEmptyRequested() -> Int? {
        guard let nextEmptyBox = self.inputCodeBoxArray.firstEmptyRequested() else { return nil }
        return nextEmptyBox.position
    }

    /**
     Returns a text conformed by all the positions requested fulfilled by user
     */
    public func fulfilledText() -> String? {
        return self.inputCodeBoxArray.fulfilledText()
    }

    /**
     Returns true if all positions requested are fulfilled by user
     */
    public func isFulfilled() -> Bool {
        return self.inputCodeBoxArray.fulfilledCount() == self.inputCodeBoxArray.requestedCount()
    }

    /**
     Returns true if it has some empty position and becomes first responder if it is
     */
    @discardableResult public override func becomeFirstResponder() -> Bool {
        guard let first = self.inputCodeBoxArray.firstEmptyRequested() else { return false }
        return first.becomeFirstResponder()
    }

    /**
    Fulfill component with characters in text (used for testing porposes)
     */
//    Añadir Snapshot tests con componentes con texto!!!
    public func setText(_ text: String) {
        for character in text.characters {
            guard let firstEmpty = self.inputCodeBoxArray.firstEmptyRequested() else { return }
            let shouldAccept = self.delegate?.codeView(self, willChange: character, for: firstEmpty.position) ?? true
            if shouldAccept {
                firstEmpty.text = character
            }
        }
    }
    
    public func setBoxView(position: NSInteger, backgroundColor: UIColor, borderWidth: CGFloat, borderColor: UIColor) {
        let boxView = self.inputCodeBoxArray[position - 1]
        boxView.layer.borderWidth = borderWidth
        boxView.layer.borderColor = borderColor.cgColor
        boxView.backgroundColor = backgroundColor
        switch boxView.getPosition() {
        case .first:
            boxView.layer.cornerRadius = 6
            boxView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .last:
            boxView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            boxView.layer.cornerRadius = 6
        default:
            break
        }
    }

    public func getPin() -> String {
        return self.inputCodeBoxArray.fulfilledText() ?? ""
    }
}

// MARK: Private
private extension PLUIInputCodeView {

    func configureInputCodeBoxArray(facade: PLUIInputCodeFacadeProtocol,
                                    elementSize: CGSize,
                                    requestedPositions: RequestedPositions) {

        let facadeConfiguration = facade.configuration()
        for position in 1...facadeConfiguration.elementsNumber {
            self.inputCodeBoxArray.append(PLUIInputCodeBoxView(position: position,
                                                               showPosition: facadeConfiguration.showPositions,
                                                               elementsNumber: facadeConfiguration.elementsNumber,
                                                               delegate: self,
                                                               requested: requestedPositions.isRequestedPosition(position: position),
                                                               isSecureEntry: facadeConfiguration.showSecureEntry,
                                                               size: elementSize,
                                                               font: facadeConfiguration.font,
                                                               textColor: facadeConfiguration.textColor,
                                                               cursorTintColor: facadeConfiguration.cursorTintColor,
                                                               borderColor: facadeConfiguration.borderColor,
                                                               borderWidth: facadeConfiguration.borderWidth))
        }
    }

    func addSubviews(view: UIView) {
        self.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    func configureAccessibilityIdentifiers() {
        self.accessibilityIdentifier = AccesibilityIdentifiers.container
    }
}

// MARK: PLUIInputCodeBoxViewDelegate
extension PLUIInputCodeView: PLUIInputCodeBoxViewDelegate {

    func codeBoxViewShouldChangeString (_ codeBoxView: PLUIInputCodeBoxView, replacementString string: String) -> Bool {
        let allowChange = self.delegate?.codeView(self, willChange: string, for: codeBoxView.position)

        guard allowChange == true else {
            codeBoxView.text = ""
            return false
        }

        if string.isBackSpace {
            return true
        }

        codeBoxView.text = string

        self.delegate?.codeView(self, didChange: string, for: codeBoxView.position)

        if let nextPasswordInputBoxView = self.inputCodeBoxArray.nextEmptyRequested(from: codeBoxView.position) {
            nextPasswordInputBoxView.becomeFirstResponder()
        } else {
            codeBoxView.resignFirstResponder()
        }

        return true
    }

    func codeBoxViewDidBeginEditing (_ codeBoxView: PLUIInputCodeBoxView) {
        let firstEmptyRequested = self.inputCodeBoxArray.firstEmptyRequested()
        if (codeBoxView.isEmpty && firstEmptyRequested != codeBoxView) {
            firstEmptyRequested?.becomeFirstResponder()
        } else {
            codeBoxView.setKeyboardType(self.keyboardType)
            self.delegate?.codeView(self, didBeginEditing: codeBoxView.position)
        }
    }

    func codeBoxViewDidEndEditing (_ codeBoxView: PLUIInputCodeBoxView) {
        self.delegate?.codeView(self, didEndEditing: codeBoxView.position)
    }

    func codeBoxViewDidDelete (_ codeBoxView: PLUIInputCodeBoxView, goToPrevious: Bool) {
        self.delegate?.codeView(self, didChange: codeBoxView.text ?? "", for: codeBoxView.position)
        if goToPrevious, let previousPasswordInputBoxView = self.inputCodeBoxArray.previousRequested(from: codeBoxView.position) {
            previousPasswordInputBoxView.becomeFirstResponder()
        }
    }
}

// MARK: Array extension
extension Array where Element == PLUIInputCodeBoxView {

    func nextEmptyRequested(from position: NSInteger) -> PLUIInputCodeBoxView? {
        guard position > 0, position < self.count else { return nil }
        return self.first { $0.requested == true && $0.position >= position && $0.text?.count == 0 }
    }

    func previousRequested(from position: NSInteger) -> PLUIInputCodeBoxView? {
        guard position > 0, position <= self.count else { return nil }
        return self.last { $0.requested == true && $0.position < position }
    }

    func firstEmptyRequested() -> PLUIInputCodeBoxView? {
        return self.first { $0.requested == true && $0.text?.count == 0 }
    }

    func isAnyFirstResponder() -> PLUIInputCodeBoxView? {
        return self.first { $0.isFirstResponder }
    }

    func fulfilledBoxViews() -> [PLUIInputCodeBoxView]? {
        return self.filter { return $0.requested == true && ($0.text ?? "").count > 0 }
    }

    func fulfilledText() -> String? {
        guard let fullfilledInputBoxArray = self.fulfilledBoxViews() else { return nil }
        return fullfilledInputBoxArray.reduce("", { result, inputBox in
            return result + (inputBox.text ?? "")
        })
    }

    func fulfilledCount() -> Int {
        guard let fulfilledInputBoxArray = self.fulfilledBoxViews() else { return 0 }
        return fulfilledInputBoxArray.count
    }

    func requestedCount() -> Int {
        return self.filter { $0.requested == true }.count
    }
}

// MARK: String extension
private extension String {

    var characters: [String] {
        return self.map { String($0) }
    }
}


import UIKit
import UI
import PLCommons

public enum BottomButtonStyle {
    case red, white, gray
}

public final class BottomButtonView: UIView {
    private let separator = UIView()
    private let button: LisboaButton
    private var buttonAction: (() -> Void)?
    private let animationSpeed: TimeInterval = 0.2
    
    public init(style: BottomButtonStyle = .red) {
        button = style == .red ? RedLisboaButton() : WhiteLisboaButton()
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    public func configure(title: String, action: @escaping () -> Void) {
        button.setTitle(title, for: .normal)
        buttonAction = action
    }
    
    public func enableButton() {
        UIView.animate(withDuration: animationSpeed) {
            self.button.isEnabled = true
            self.button.alpha = 1.0
        }
        
    }
    
    public func disableButton() {
        UIView.animate(withDuration: animationSpeed) {
            self.button.isEnabled = false
            self.button.alpha = 0.3
        }
    }
    
    private func setUp() {
        configureTargets()
        configureSubviews()
        applyStyling()
        setIdentifiers()
    }
    
    private func configureTargets() {
        button.addAction { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.buttonAction?()
        }
    }
    
    private func configureSubviews() {
        addSubview(separator)
        addSubview(button)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            button.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func applyStyling() {
        separator.backgroundColor = .lightSanGray
    }
    
    func setIdentifiers() {
        self.accessibilityIdentifier = AccessibilityCommons.BottomButtonView.root.id
        button.accessibilityIdentifier = AccessibilityCommons.BottomButtonView.button.id
    }
    
}

import UI
import Commons
import PLCommons
import PLUI

class BLIKConfirmationProgressView: UIStackView, ProgressBarPresentable {
    let progressBar: ProgressBar = {
        let bar = ProgressBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setProgresColor(.darkTorquoise)
        bar.setProgressBackgroundColor(.white)
        bar.setProgressAlpha(1)
        return bar
    }()
    
    var animator: UIViewPropertyAnimator?

    private let expirationLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .text, type: .regular, size: 16)
        label.textColor = .lisboaGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .text, type: .regular, size: 12)
        label.textColor = .lisboaGray
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.text = localized("pl_blik_text_informConfirm")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressBar.setRoundedCorners()
    }
    
    func setRemainingSeconds(_ seconds: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
        
        let minutes = seconds / 60
        let seconds = seconds % 60
        let time = "\(localized("pl_blik_text_transValid")) \(minutes):\(numberFormatter.string(from: NSNumber(integerLiteral: seconds))!) \(localized("pl_blik_text_codeValidTime"))"
        expirationLabel.text = time
    }
}

private extension BLIKConfirmationProgressView {
    func setup() {
        addSubviews()
        prepareStyles()
        prepareLayout()
        setIdentifiers()
    }
    
    func addSubviews() {
        addArrangedSubview(progressBar)
        addArrangedSubview(expirationLabel)
        addArrangedSubview(infoLabel)
    }
    
    func prepareStyles() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .center
        spacing = 16
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 20, left: 0, bottom: 16, right: 0)
    }
    
    func prepareLayout() {
        NSLayoutConstraint.activate([
            progressBar.widthAnchor.constraint(
                equalToConstant: Screen.resolution.width / 1.5
            ),
            progressBar.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    func setIdentifiers() {
        self.accessibilityIdentifier = AccessibilityBLIK.ConfirmationProgressView.root.id
        progressBar.accessibilityIdentifier = AccessibilityBLIK.ConfirmationProgressView.progressBar.id
        expirationLabel.accessibilityIdentifier = AccessibilityBLIK.ConfirmationProgressView.expirationLabel.id
        infoLabel.accessibilityIdentifier = AccessibilityBLIK.ConfirmationProgressView.infoLabel.id
    }
}

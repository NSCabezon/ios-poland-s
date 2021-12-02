import Commons
import UI
import PLCommons
import PLUI

class BLIKView: UIStackView, ProgressBarPresentable {
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .text, type: .regular, size: 35)
        label.textColor = .lisboaGray
        return label
    }()
    
    let progressBar: ProgressBar = {
        let bar = ProgressBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setProgresColor(.darkTorquoise)
        bar.setProgressBackgroundColor(.clear)
        bar.setProgressAlpha(1)
        return bar
    }()
    
    private let expirationLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .text, type: .regular, size: 16)
        label.textColor = .lisboaGray
        return label
    }()
    
    private lazy var copyButton: UIButton = {
        let btn = OutlinedButton()
        btn.accentColor = .santanderRed
        btn.set(localizedStylableText: .init(text: localized("pl_blik_button_copyCode"), styles: nil), state: .normal)
        btn.setImage(Images.copy.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var generateButton: UIButton = {
        let btn = LisboaButton()
        btn.configureAsRedButton()
        btn.setTitle(localized("pl_blik_button_newCodeGen"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addAction { [weak self] in
            self?.onGenerateTapped?()
        }
        return btn
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lisboaGray
        label.configureText(
            withKey: "pl_blik_text_informHowTo",
            andConfiguration: .init(
                font: .santander(family: .text, type: .regular, size: 12),
                alignment: .center,
                lineHeightMultiple: 1.2)
        )
        return label
    }()
    
    var animator: UIViewPropertyAnimator?
    
    var onCopyTapped: ((String) -> Void)?
    var onGenerateTapped: (() -> Void)?
    
    var isGenerateButtonHidden: Bool {
        get { generateButton.isHidden }
        set { generateButton.isHidden = newValue }
    }
    
    var isAllHidden: Bool {
        get { !arrangedSubviews.map(\.isHidden).contains(false) }
        set { arrangedSubviews.forEach { $0.isHidden = newValue } }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        copyButton.layer.cornerRadius = copyButton.frame.height / 2
        progressBar.setRoundedCorners()
    }
    
    func setCode(_ code: String) {
        codeLabel.text = code
    }
    
    func setRemainingSeconds(_ seconds: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
        
        let minutes = seconds / 60
        let seconds = seconds % 60
        let time = "\(minutes):\(numberFormatter.string(from: NSNumber(integerLiteral: seconds))!)"
        
        let timeString = "\(localized("pl_blik_text_codeValid")) \(time) \(localized("pl_blik_text_codeValidTime"))"
        let attrString = NSMutableAttributedString(string: timeString)
        
        let range = attrString.mutableString.range(of: time, options: .caseInsensitive)
        attrString.addAttribute(.font, value: UIFont.santander(family: .text, type: .bold, size: 16), range: range)
        expirationLabel.attributedText = attrString
    }
}

private extension BLIKView {
    func setup() {
        addSubviews()
        prepareStyles()
        prepareLayout()
        setIdentifiers()
    }
    
    func addSubviews() {
        addArrangedSubview(codeLabel)
        addArrangedSubview(progressBar)
        addArrangedSubview(expirationLabel)
        addArrangedSubview(copyButton)
        addArrangedSubview(generateButton)
        addArrangedSubview(descriptionLabel)
    }
    
    func prepareStyles() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .center
        spacing = 18
    }
    
    func prepareLayout() {
        NSLayoutConstraint.activate([
            progressBar.widthAnchor.constraint(
                equalToConstant: Screen.resolution.width / 1.5
            ),
            progressBar.heightAnchor.constraint(equalToConstant: 5),
            
            generateButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            generateButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            generateButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc
    func copyButtonTapped() {
        onCopyTapped?(codeLabel.text?.notWhitespaces() ?? "")
    }
    
    func setIdentifiers() {
        self.accessibilityIdentifier = AccessibilityBLIK.BLIKView.root.id
        codeLabel.accessibilityIdentifier = AccessibilityBLIK.BLIKView.codeLabel.id
        progressBar.accessibilityIdentifier = AccessibilityBLIK.BLIKView.progressBar.id
        expirationLabel.accessibilityIdentifier = AccessibilityBLIK.BLIKView.expirationLabel.id
        copyButton.accessibilityIdentifier = AccessibilityBLIK.BLIKView.copyButton.id
        generateButton.accessibilityIdentifier = AccessibilityBLIK.BLIKView.generateButton.id
        descriptionLabel.accessibilityIdentifier = AccessibilityBLIK.BLIKView.descriptionLabel.id
    }
}

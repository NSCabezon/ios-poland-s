
import UI
import CoreFoundationLib

protocol TransferDateOptionDelegate: AnyObject {
    func didSelectOption(_ option: DateTransferOption)
}

class TransferDateSegmentOptionView: UIView {
    
    let option: DateTransferOption
    var isSelected: Bool {
        didSet {
            prepareStyles()
        }
    }
    private let label = UILabel()
    private let overlayButton = UIButton()
    
    weak var delegate: TransferDateOptionDelegate?
    
    init(option: DateTransferOption, isSelected: Bool, delegate: TransferDateOptionDelegate?) {
        self.option = option
        self.isSelected = isSelected
        self.delegate = delegate
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TransferDateSegmentOptionView {
    
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(label)
        addSubview(overlayButton)
    }
    
    func prepareStyles() {
        backgroundColor = isSelected ? .white : .clear
        layer.borderWidth = 1
        layer.borderColor = isSelected ? UIColor.mediumSkyGray.cgColor : UIColor.clear.cgColor
        layer.cornerRadius = 8
        
        label.applyStyle(LabelStylist(textColor: isSelected ? .darkTorquoise : .lisboaGray,
                                      font: isSelected ? Const.Font.selectedFont : Const.Font.unselectedFont,
                                      textAlignment: .center))
        label.text = option == .today ? localized("pl_foundtrans_text_whenToday") : localized("pl_foundtrans_text_whenAnotherDay")
        if isSelected {
            drawShadow(offset: (x: 0, y: 2),
                       opacity: 0.5,
                       color: .lightSanGray,
                       radius: 4)
        }
        
        overlayButton.backgroundColor = .clear
        overlayButton.setTitle("", for: .normal)
        overlayButton.addTarget(self, action: #selector(didTapOption), for: .touchUpInside)
    }
    
    func setUpLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: Const.Padding.label.top),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.Padding.label.left),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Const.Padding.label.right),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Const.Padding.label.bottom),
            
            overlayButton.topAnchor.constraint(equalTo: topAnchor),
            overlayButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc func didTapOption() {
        delegate?.didSelectOption(option)
    }
}

private extension TransferDateSegmentOptionView {
    
    struct Const {
        struct Padding {
            static let label: UIEdgeInsets = .init(top: 6, left: 8, bottom: -6, right: -8)
        }
        struct Font {
            static let selectedFont: UIFont = .santander(family: .micro, type: .bold, size: 14)
            static let unselectedFont: UIFont = .santander(family: .micro, type: .regular, size: 14)
        }
    }
}

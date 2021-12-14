
public protocol TransferDateSelectorDelegate: AnyObject {
    func didSelectDate(date: Date)
}

public class TransferDateSelector: UIView {
    
    private let stackView = UIStackView()
    private let segmentView = TransferDateSegmentView()
    private let anotherDateView: AnotherDateView
    public weak var delegate: TransferDateSelectorDelegate?
    
    public init(language: String,
                dateFormatter: DateFormatter) {
        anotherDateView = AnotherDateView(language: language, dateFormatter: dateFormatter)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TransferDateSelector {
    
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(segmentView)
        stackView.addArrangedSubview(anotherDateView)
    }
    
    func prepareStyles() {
        stackView.axis = .vertical
        stackView.spacing = 24
        
        segmentView.delegate = self
        
        anotherDateView.isHidden = true
        anotherDateView.delegate = self
    }
    
    func setUpLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

extension TransferDateSelector: TransferDateSegmentViewDelegate {
    
    func didSelectOption(_ option: DateTransferOption) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.anotherDateView.isHidden = !(option == .anotherDay)
            self?.anotherDateView.alpha = option == .anotherDay ? 1 : 0
        }
        switch option {
        case .today:
            delegate?.didSelectDate(date: Date())
        case .anotherDay:
            delegate?.didSelectDate(date: anotherDateView.getSelectedDate())
        }
    }
}

extension TransferDateSelector: AnotherDayViewDelegate {
    func didSelectDate() {
        delegate?.didSelectDate(date: anotherDateView.getSelectedDate())
    }
}

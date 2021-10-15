import Commons
import PLUI
import UI

typealias SeparatorLine = LoanScheduleDetailsViewModel.SeparatorLine

private enum Constants {
    static let separatorLineColor = UIColor.lightSanGray
    static let separatorLineMargin: CGFloat = 17
    static func height(for separatorLine: SeparatorLine) -> CGFloat {
        switch separatorLine {
        case .none: return 20
        case .whole: return 32
        case .withMargins: return 24
        }
    }
}

final class LoanScheduleDetailSeparatorView: UIView {
    
    private let innerSeparatorLineView: UIView = UIView()
    
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        setUpSubviews()
        setUpLayout()
        setUpStyle()
    }
    
    private func setUpSubviews() {
        addSubview(innerSeparatorLineView)
    }
    
    private func setUpLayout() {
        innerSeparatorLineView.translatesAutoresizingMaskIntoConstraints = false
        leftConstraint = innerSeparatorLineView.leftAnchor.constraint(equalTo: leftAnchor)
        rightConstraint = innerSeparatorLineView.rightAnchor.constraint(equalTo: rightAnchor)
        heightConstraint = heightAnchor.constraint(equalToConstant: Constants.height(for: .none))
        NSLayoutConstraint.activate([
            innerSeparatorLineView.centerYAnchor.constraint(equalTo: centerYAnchor),
            innerSeparatorLineView.heightAnchor.constraint(equalToConstant: 1),
            leftConstraint,
            rightConstraint,
            heightConstraint
        ])
    }
    
    private func setUpStyle() {
        innerSeparatorLineView.backgroundColor = Constants.separatorLineColor
    }
    
    func setUp(separatorLine: SeparatorLine) {
        switch separatorLine {
        case .none:
            innerSeparatorLineView.isHidden = true
        case .whole:
            innerSeparatorLineView.isHidden = false
            leftConstraint.constant = 0
            rightConstraint.constant = 0
        case .withMargins:
            innerSeparatorLineView.isHidden = false
            leftConstraint.constant = Constants.separatorLineMargin
            rightConstraint.constant = -Constants.separatorLineMargin
        }
        heightConstraint.constant = Constants.height(for: separatorLine)
    }
}

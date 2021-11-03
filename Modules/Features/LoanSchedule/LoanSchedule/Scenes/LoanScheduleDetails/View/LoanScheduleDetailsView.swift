import Commons
import PLUI
import UI

private enum Constants {
    static let scrollViewContentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
}

final class LoanScheduleDetailsView: UIView {
    
    private let contentView = PLScrollableStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .white
        setUpSubviews()
        setUpLayout()
        contentView.contentInset = Constants.scrollViewContentInset
    }
    
    private func setUpSubviews() {
        addSubview(contentView)
    }
    
    private func setUpLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setUp(withViewModel viewModel: LoanScheduleDetailsViewModel) {
        viewModel.elements.forEach { element in
            let detailView = LoanScheduleDetailValueView()
            detailView.setUp(
                title: element.title,
                value: element.value,
                fontStyle: element.valueStyle
            )
            contentView.addArrangedSubview(detailView)
            
            let separatorView = LoanScheduleDetailSeparatorView()
            separatorView.setUp(separatorLine: element.separatorLine)
            contentView.addArrangedSubview(separatorView)
        }
    }
}

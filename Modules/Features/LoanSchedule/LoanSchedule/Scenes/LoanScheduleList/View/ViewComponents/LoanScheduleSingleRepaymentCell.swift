import CoreFoundationLib
import PLUI
import UI

private enum Constants {
    static let repaymentValueTextFont = UIFont.santander(family: .headline, type: .bold, size: 24.0)
    static let repaymentDateTextFont = UIFont.santander(family: .micro, type: .regular, size: 12.0)
    static let descriptionTextFont = UIFont.santander(family: .micro, type: .regular, size: 14.0)
    static let loanTotalTextFont = UIFont.santander(family: .micro, type: .bold, size: 14)
}

class LoanScheduleSingleRepaymentCell: UITableViewCell {
    public static var identifier = "LoanScheduleSingleRepaymentCell"
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.drawRoundedBorderAndShadow(with: ShadowConfiguration(color: .lightSanGray,
                                                                  opacity: 0.5,
                                                                  radius: 2.0,
                                                                  withOffset: 0.0,
                                                                  heightOffset: 2.0),
                                        cornerRadius: 4.0,
                                        borderColor: .lightSkyBlue,
                                        borderWith: 1.0)
        addSubview(view)
        return view
    }()
    
    private lazy var repaymentValueLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .left
        label.textColor = .lisboaGray
        label.font = Constants.repaymentValueTextFont
        shadowView.addSubview(label)
        return label
    }()
    
    private lazy var accessoryImageView: UIImageView = {
        let view = UIImageView()
        view.image = PLAssets.image(named: "chevronRightIcon")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .darkTorquoise
        shadowView.addSubview(view)
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .left
        label.textColor = .lisboaGray
        label.font = Constants.repaymentDateTextFont
        shadowView.addSubview(label)
        return label
    }()
    
    private lazy var separatorView: DashedLineView = {
       let view = DashedLineView()
        shadowView.addSubview(view)
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .left
        label.textColor = .brownishGray
        label.font = Constants.descriptionTextFont
        shadowView.addSubview(label)
        return label
    }()
    
    private lazy var loanTotalLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .right
        label.textColor = .lisboaGray
        label.font = Constants.loanTotalTextFont
        shadowView.addSubview(label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        setUpView()
        setUpLayouts()
    }
    
    private func setUpView() {
        selectionStyle = .none
    }
    
    private func setUpLayouts() {
        
        [shadowView, repaymentValueLabel, accessoryImageView, dateLabel, separatorView, descriptionLabel, loanTotalLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let marginConstant: CGFloat = 16
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            repaymentValueLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: marginConstant),
            repaymentValueLabel.trailingAnchor.constraint(equalTo: accessoryImageView.leadingAnchor, constant: -10),
            repaymentValueLabel.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: marginConstant),
            repaymentValueLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -1),
            
            accessoryImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -marginConstant),
            accessoryImageView.centerYAnchor.constraint(equalTo: repaymentValueLabel.centerYAnchor, constant: 0),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 24),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 24),
            
            dateLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: marginConstant),
            dateLabel.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -marginConstant),
            dateLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -6),
            
            separatorView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: marginConstant),
            separatorView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -marginConstant),
            separatorView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: marginConstant),
            descriptionLabel.trailingAnchor.constraint(equalTo: loanTotalLabel.leadingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -marginConstant),
            
            loanTotalLabel.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -marginConstant),
            loanTotalLabel.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor)
        ])
    }
}

extension LoanScheduleSingleRepaymentCell {
    public func setUp(with viewModel: LoanScheduleListItemViewModel) {
        repaymentValueLabel.text = viewModel.repaymentValue
        dateLabel.text = viewModel.repaymentDate
        descriptionLabel.text = viewModel.description
        loanTotalLabel.text = viewModel.loanTotal
    }
}

import CoreFoundationLib
import PLUI
import UI

private enum Constants {
    static let headerTitleTextFont = UIFont.santander(family: .micro, type: .bold, size: 20)
}

final class LoanScheduleListView: UIView {
    let tableView = UITableView(frame: .zero, style: .grouped)
    private let headerTitleLabel = UILabel()
    private let informationView = LoanScheduleInformationHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setTitle(_ text: String) {
        headerTitleLabel.text = text
    }
    
    private func setUp() {
        backgroundColor = .white
        
        setUpSubviews()
        setUpLayout()
        setUpTitleLabel()
        setUpTableView()
        registerHeaderFooter()
        registerCells()
    }
    
    private func setUpSubviews() {
        addSubview(headerTitleLabel)
        addSubview(tableView)
    }
    
    private func setUpLayout() {
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22),
            headerTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            headerTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 18),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpTitleLabel() {
        headerTitleLabel.textColor = .lisboaGray
        headerTitleLabel.font = Constants.headerTitleTextFont
    }
    
    private func setUpTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorColor = .clear
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.backgroundColor = .white
    }
    
    private func registerHeaderFooter() {
        tableView.register(LoanScheduleInformationHeaderView.self, forHeaderFooterViewReuseIdentifier: LoanScheduleInformationHeaderView.identifier)
    }
    
    private func registerCells() {
        tableView.register(LoanScheduleSingleRepaymentCell.self, forCellReuseIdentifier: LoanScheduleSingleRepaymentCell.identifier)
    }
}

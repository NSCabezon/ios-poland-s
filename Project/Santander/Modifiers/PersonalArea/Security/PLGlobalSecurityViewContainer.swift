import PersonalArea
import CoreFoundationLib
import UI

final class PLGlobalSecurityViewContainer {
    private let viewComponent: GlobalSecurityViewComponentsProtocol
    private let mainStackView = UIStackView()
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.viewComponent = GlobalSecurityViewComponents()
    }
}

extension PLGlobalSecurityViewContainer: GlobalSecurityViewContainerProtocol {
    func createView(data: GlobalSecurityViewDataComponentsProtocol?, delegate: GlobalSecurityViewDelegate?) -> UIView {
        self.viewComponent.dataComponents = data
        self.viewComponent.delegate = delegate
        self.configureStackView()
        self.createLastLogonView()
        self.createFirstRow(data)
        let view = UIView()
        view.addSubview(self.mainStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.mainStackView.leadingAnchor, constant: -16.0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.mainStackView.trailingAnchor, constant: 16.0).isActive = true
        view.topAnchor.constraint(equalTo: self.mainStackView.topAnchor, constant: -16.0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.mainStackView.bottomAnchor, constant: 23.0).isActive = true
        return view
    }
}

private extension PLGlobalSecurityViewContainer {
    func createLastLogonView() {
        guard let view = self.viewComponent.setLastLogonView() else { return }
        view.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
        self.addToMainView(view)
    }
    
    func createFirstRow(_ data: GlobalSecurityViewDataComponentsProtocol?) {
        let stackViewRow = UIStackView()
        stackViewRow.translatesAutoresizingMaskIntoConstraints = false
        stackViewRow.axis = .horizontal
        stackViewRow.spacing = 8
        stackViewRow.distribution = .fillEqually
        stackViewRow.heightAnchor.constraint(equalToConstant: 184.0).isActive = true
        let phoneLocalizedFraud = localized("helpCenter_button_helpCall", [StringPlaceholder(.phone, data?.fraudViewModel?.phone ?? "")])
        let phoneLocalizedTheft = localized("general_button_call", [StringPlaceholder(.phone, data?.fraudViewModel?.phone ?? "")])
        let fraudView = self.viewComponent.setReportFraudView(phoneLocalizedFraud, viewStyle: .hideNumberLabel)
        stackViewRow.addArrangedSubview(fraudView)
        let stackViewColumnSecond = UIStackView()
        stackViewColumnSecond.translatesAutoresizingMaskIntoConstraints = false
        stackViewColumnSecond.axis = .vertical
        stackViewColumnSecond.spacing = 8
        stackViewColumnSecond.distribution = .fillEqually
        let stolenView = self.viewComponent.setStolenView(phoneLocalizedTheft, viewStyle: .showNumberLabel)
        stackViewColumnSecond.addArrangedSubview(stolenView)
        let alertView = self.viewComponent.setSmallAlertView { [weak self] in
            self?.didSelectSmallAlertView()
        }
        stackViewColumnSecond.addArrangedSubview(alertView)
        stackViewRow.addArrangedSubview(stackViewColumnSecond)
        self.addToMainView(stackViewRow)
    }
    
    func configureStackView() {
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.mainStackView.axis = .vertical
        self.mainStackView.spacing = 8
        self.mainStackView.distribution = .fill
    }
    
    func addToMainView(_ view: UIView) {
        self.mainStackView.addArrangedSubview(view)
    }
    
    func didSelectSmallAlertView() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}

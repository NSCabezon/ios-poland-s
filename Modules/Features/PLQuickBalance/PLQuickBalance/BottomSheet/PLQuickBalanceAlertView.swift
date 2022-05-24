import UI
import CoreFoundationLib
import UIOneComponents

protocol PLQuickBalanceAlertViewDelegate {
    func dismissPLQuickBalanceAlertView()
    func showSettings()
}


class PLQuickBalanceAlertView: UIView {
    let icon = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let buttonsStackView = UIStackView()
    let viewModel: PLQuickBalanceAlertViewModel = PLQuickBalanceAlertViewModel()
    var delegate: PLQuickBalanceAlertViewDelegate?
    
    init(delegate: PLQuickBalanceAlertViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureButtonsStackView()
        configureView()
        configureConstraints()
        
    }
    
    private func configureButtonsStackView() {
        let cancelButton = makeButton(text: viewModel.cancelButtonTitle, backgroundColor: .white, titleColor: .bostonRed)
        let acceptButton = makeButton(text: viewModel.acceptButtonTitle, backgroundColor: .bostonRed, titleColor: .white)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .center
        buttonsStackView.spacing = 16
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(acceptButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelButtonAction() {
        delegate?.dismissPLQuickBalanceAlertView()
    }
    
    @objc func acceptButtonAction() {
        delegate?.showSettings()
    }
    
    private func makeButton(text: String, backgroundColor: UIColor, titleColor: UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .santander(family: .micro, type: .bold, size: 16)
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)
        button.layer.cornerRadius = 24
        button.setTextAligment(.center, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        button.drawShadow(offset: (x: 1, y: 2), opacity: 1, color: .coolGray, radius: 3)
        return button
    }
    
    private func configureView() {
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(buttonsStackView)
        icon.image = viewModel.image
        
        titleLabel.text = viewModel.title
        titleLabel.font = UIFont.santander(family: .headline, type: .bold, size: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.lisboaGray
        
        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.santander(family: .text, type: .regular, size: 16)
        subtitleLabel.textColor = UIColor.lisboaGray
    }
    
    private func configureConstraints() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 65),
            icon.widthAnchor.constraint(equalToConstant: 65),
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            icon.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            titleLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
        ])
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 54),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -54),
            buttonsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
    
}

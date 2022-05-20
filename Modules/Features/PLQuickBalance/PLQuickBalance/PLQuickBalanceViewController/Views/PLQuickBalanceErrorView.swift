import Foundation
import CoreFoundationLib

class PLQuickBalanceErrorView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        titleLabel.text = localized("pl_quickView_errorTitle_unavailable")
        subtitleLabel.text = localized("pl_quickView_errorText_unavailable")
        
        titleLabel.textColor = .black
        subtitleLabel.textColor = UIColor.Legacy.lisboaGrayNew
        
        titleLabel.font = UIFont.santander(family: .text, type: .regular, size: 26)
        subtitleLabel.font = UIFont.santander(family: .text, type: .regular, size: 14)
        subtitleLabel.numberOfLines = 0
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

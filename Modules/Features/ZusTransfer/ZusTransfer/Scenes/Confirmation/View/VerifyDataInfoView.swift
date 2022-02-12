
import Foundation
import UI
import CoreFoundationLib

class VerifyDataInfoView: UIView {
    private let infoLabel = UILabel()
    private let iconView = UIImageView()
    private let iconBackgroundView = UIView()
    private let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension VerifyDataInfoView {
    func setUp() {
        addSubviews()
        configureView()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconBackgroundView)
        stackView.addArrangedSubview(infoLabel)
        iconBackgroundView.addSubview(iconView)
    }
    
    func configureView() {
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        infoLabel.numberOfLines = 0
        infoLabel.text = localized("pl_zusTransfer_text_notice")
        infoLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                          font: .santander(family: .text, type: .regular, size: 14),
                                          textAlignment: .left))
        
        iconView.image = Assets.image(named: "icnInfo")?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = .black
        
        iconBackgroundView.backgroundColor = Consts.Colors.iconBackgroundColor
        iconBackgroundView.clipsToBounds = true
    }
    
    func setUpLayout() {
        [infoLabel, iconView, iconBackgroundView, stackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 48),
            iconBackgroundView.widthAnchor.constraint(equalTo: iconBackgroundView.heightAnchor),
            
            iconView.leadingAnchor.constraint(equalTo: iconBackgroundView.leadingAnchor, constant: 10),
            iconView.topAnchor.constraint(equalTo: iconBackgroundView.topAnchor, constant: 10),
            iconView.trailingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: -10),
            iconView.bottomAnchor.constraint(equalTo: iconBackgroundView.bottomAnchor, constant: -10),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44)
        ])
        iconBackgroundView.layoutIfNeeded()
        iconBackgroundView.layer.cornerRadius = iconBackgroundView.frame.width / 2
    }
}

private extension VerifyDataInfoView {
    struct Consts {
        struct Colors {
            static let iconBackgroundColor: UIColor = .init(red: 255/255, green: 246/255, blue: 206/255, alpha: 1)
        }
    }
}

//
//  WarningBubbleView.swift
//  PLUI
//
//  Created by 185167 on 22/02/2022.
//

public final class WarningBubbleView: UIView {
    private let warningIcon = UIImageView()
    private let warningLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatible with truth and beauty!")
    }
    
    public func configure(with warningText: String) {
        warningLabel.text = warningText
    }
    
    private func setUp() {
        configureLayout()
        configureStyling()
    }
    
    private func configureLayout() {
        [warningIcon, warningLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            warningIcon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            warningIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            warningIcon.heightAnchor.constraint(equalToConstant: 16),
            warningIcon.widthAnchor.constraint(equalToConstant: 16),
            
            warningLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            warningLabel.leadingAnchor.constraint(equalTo: warningIcon.trailingAnchor, constant: 16),
            warningLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            warningLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
    
    private func configureStyling() {
        layer.cornerRadius = 4
        layer.masksToBounds = false
        backgroundColor = .sky
        
        warningIcon.image = PLAssets.image(named: "info_blueGreen")
        
        warningLabel.numberOfLines = 0
        warningLabel.textColor = .lisboaGray
        warningLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
    }
}

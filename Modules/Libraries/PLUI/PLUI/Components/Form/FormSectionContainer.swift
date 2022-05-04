//
//  FormSectionContainer.swift
//  PLUI
//
//  Created by 185167 on 20/12/2021.
//

import UI
import CoreFoundationLib

public final class FormSectionContainer: UIView {
    private let sectionHeader = UILabel()
    private let infoButton = UIButton()
    private let infoButtonMode: InfoButtonMode
    private let containedView: UIView
    
    public init(
        containedView: UIView,
        sectionTitle: String,
        infoButtonMode: InfoButtonMode = .disabled
    ) {
        self.containedView = containedView
        self.infoButtonMode = infoButtonMode
        super.init(frame: .zero)
        setUp(with: sectionTitle)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
}

private extension FormSectionContainer {
    func setUp(with sectionTitle: String) {
        configureSubviews()
        configureStyling()
        configureInfoButton()
        sectionHeader.text = sectionTitle
    }
    
    func configureSubviews() {
        [sectionHeader, containedView, infoButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            sectionHeader.topAnchor.constraint(equalTo: topAnchor),
            sectionHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sectionHeader.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -8),
            
            containedView.topAnchor.constraint(equalTo: sectionHeader.bottomAnchor, constant: 8),
            containedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            infoButton.heightAnchor.constraint(equalToConstant: 20),
            infoButton.widthAnchor.constraint(equalToConstant: 20),
            infoButton.centerYAnchor.constraint(equalTo: sectionHeader.centerYAnchor),
            infoButton.leadingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
    
    func configureStyling() {
        sectionHeader.numberOfLines = 1
        sectionHeader.textColor = .lisboaGray
        sectionHeader.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
    }
    
    func configureInfoButton() {
        switch infoButtonMode {
        case .disabled:
            infoButton.isHidden = true
        case let .enabled(text):
            enableInfoButton(with: text)
        }
    }
    
    func enableInfoButton(with text: String) {
        infoButton.setImage(PLAssets.image(named: "info_blueGreen"), for: .normal)
        infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
    }
    
    @objc func didTapInfoButton(_ sender: UIButton) {
        switch infoButtonMode {
        case let .enabled(localizedTextKey):
            let styledText: LocalizedStylableText = localized(localizedTextKey)
            BubbleLabelView.startWith(
                associated: sender,
                localizedStyleText: styledText,
                position: .bottom
            )
        case .disabled:
            break
        }
    }
}

extension FormSectionContainer {
    public enum InfoButtonMode {
        case enabled(LocalizedTextKey)
        case disabled
        
        public typealias LocalizedTextKey = String
    }
}

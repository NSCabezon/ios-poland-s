//
//  EmptySearchResultCell.swift
//  PLScenes
//
//  Created by 185167 on 19/04/2022.
//

import PLUI

final class EmptySearchResultCell: UITableViewCell {
    public static let identifier = String(describing: EmptySearchResultCell.self)
    
    private let backgroundImage = UIImageView()
    private let titleMessageLabel = UILabel()
    private let searchPhraseLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(titleMessageText: String, searchPhraseText: String) {
        titleMessageLabel.text = titleMessageText
        searchPhraseLabel.text = searchPhraseText
    }
    
    private func setUp() {
        configureLayout()
        configureStyling()
        configureBackground()
    }
    
    private func configureLayout() {
        [backgroundImage, titleMessageLabel, searchPhraseLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            titleMessageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -16),
            titleMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            searchPhraseLabel.topAnchor.constraint(equalTo: titleMessageLabel.bottomAnchor, constant: 20),
            searchPhraseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchPhraseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureStyling() {
        titleMessageLabel.textAlignment = .center
        titleMessageLabel.numberOfLines = 2
        titleMessageLabel.textColor = .lisboaGray
        titleMessageLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 18
        )
        
        searchPhraseLabel.textAlignment = .center
        searchPhraseLabel.numberOfLines = 1
        searchPhraseLabel.textColor = .lisboaGray
        searchPhraseLabel.font = .santander(
            family: .micro,
            type: .bold,
            size: 18
        )
    }
    
    private func configureBackground() {
        backgroundImage.image = PLAssets.image(named: "leavesEmpty")
        backgroundImage.contentMode = .scaleAspectFit
    }
}

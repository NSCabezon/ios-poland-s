//
//  ItemSearchView.swift
//  PLScenes
//
//  Created by 185167 on 09/02/2022.
//

import UI
import CoreFoundationLib

final class ItemSearchView: UIView {
    private let searchField = LisboaTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setUpdateDelegate(_ delegate: UpdatableTextFieldDelegate) {
        searchField.updatableDelegate = delegate
    }
    
    func getSearchText() -> String {
        return searchField.text ?? ""
    }
    
    private func setUp() {
        configureLayout()
        configureStyling()
    }
    
    private func configureLayout() {
        addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            searchField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            searchField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configureStyling() {
        backgroundColor = .white
    
        let formatter = UIFormattedCustomTextField()
        formatter.setAllowOnlyCharacters(CharacterSet(charactersIn: localized("digits_operative")))
        
        searchField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .floatingTitle,
                    formatter: formatter,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: nil
                )
            )
        )
        searchField.setStyle(LisboaTextFieldStyle.default)
        searchField.setRightAccessory(.image("icnSearch", action: {}))
        searchField.setPlaceholder(localized("#Szukaj"))
    }
}


//
//  ItemSearchView.swift
//  PLScenes
//
//  Created by 185167 on 09/02/2022.
//

import UI
import CoreFoundationLib

final class ItemSearchView: UIView {
    private let searchView = SearchFieldView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setUpdateDelegate(_ delegate: UpdatableTextFieldDelegate) {
        searchView.textField.updatableDelegate = delegate
    }
    
    func getSearchText() -> String {
        return searchView.textField.text ?? ""
    }
    
    func setPlaceholderText(_ placeholderText: String) {
        searchView.updateTitle(placeholderText)
    }
    
    private func setUp() {
        configureLayout()
    }
    
    private func configureLayout() {
        addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            searchView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            searchView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}


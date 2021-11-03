//
//  MenuView.swift
//  BLIK
//
//  Created by 186492 on 07/06/2021.
//

import UIKit
import PLCommons

class MenuView<Item: MenuViewModel>: UIStackView {
    var onItemTapped: ((Item) -> Void)?
    
    init() {
        super.init(frame: .zero)
        self.accessibilityIdentifier = AccessibilityBLIK.MenuView.root.id
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItems(_ items: [Item]) {
        removeAllArrangedSubviews()
        
        for item in items {
            let view = MenuItemView(model: item)
            addArrangedSubview(view)
            view.accessibilityIdentifier = AccessibilityBLIK.MenuView.root.id + ".\(item.title)"
            
            view.onTapped = { [weak self] in
                self?.onItemTapped?(item)
            }
        }
    }
}

private extension MenuView {
    func setup() {
        axis = .vertical
        spacing = 11
    }
}

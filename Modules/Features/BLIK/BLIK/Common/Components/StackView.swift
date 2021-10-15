//
//  StackView.swift
//  BLIK
//
//  Created by 186492 on 08/06/2021.
//

import UIKit

class HStackView: UIStackView {
    init(_ views: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        self.spacing = spacing
        views.forEach { addArrangedSubview($0) }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VStackView: HStackView {
    override init(_ views: [UIView], spacing: CGFloat = 0) {
        super.init(views, spacing: spacing)
        axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

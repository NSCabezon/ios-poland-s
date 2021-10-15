//
//  NotificationsInboxListView.swift
//  mCommerce
//

import UI
import PLUI
import Commons

private enum Constants {
    static let backgroundColor = UIColor.white
}

final class NotificationsInboxListView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        backgroundColor = Constants.backgroundColor
        
        setUpSubviews()
        setUpLayout()
    }
    
    private func setUpSubviews() {
        // TODO: In future user story
    }
    
    private func setUpLayout() {
        // TODO: In future user story
    }
    
}

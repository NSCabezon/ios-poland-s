//
//  NotificationsInboxListView.swift
//  NotificationsInbox
//

import UI
import PLUI
import Commons

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
        backgroundColor = .white
        
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

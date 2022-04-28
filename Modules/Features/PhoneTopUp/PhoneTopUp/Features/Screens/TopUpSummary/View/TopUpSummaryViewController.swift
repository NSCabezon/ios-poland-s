//
//  TopUpSummaryViewController.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/01/2022.
//

import Operative
import UI
import CoreFoundationLib

final class TopUpSummaryViewController: OperativeSummaryViewController {
    // MARK: Properties
    private let presenter: TopUpSummaryPresenterProtocol
    
    // MARK: Lifecycle
    init(presenter: TopUpSummaryPresenterProtocol) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    override func setupNavigationBar() {
        let builder = NavigationBarBuilder(style: .sky, title: .title(key: "genericToolbar_title_confirmation"))
        builder.setRightActions(.close(action: .selector(#selector(close))))
        builder.build(on: self, with: nil)
    }
    
    // MARK: Actions
    
    @objc
    func close() {
        presenter.didSelectClose()
    }
}

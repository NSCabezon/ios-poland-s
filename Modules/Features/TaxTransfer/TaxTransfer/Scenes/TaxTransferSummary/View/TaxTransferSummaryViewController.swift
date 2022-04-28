//
//  TaxTransferSummaryViewController.swift
//  TaxTransfer
//
//  Created by 187831 on 21/03/2022.
//

import UI
import Operative

final class TaxTransferSummaryViewController: OperativeSummaryViewController {
    private let presenter: TaxTransferSummaryPresenterProtocol
    
    init(presenter: TaxTransferSummaryPresenterProtocol) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupNavigationBar() {
        let navigationBarBuilder = NavigationBarBuilder(
            style: .sky,
            title: .title(
                key: "genericToolbar_title_summary"
            )
        )
        navigationBarBuilder.setRightActions(.close(action: .selector(#selector(close))))
        navigationBarBuilder.build(on: self, with: nil)
    }
}

private extension TaxTransferSummaryViewController {
    @objc func close() {
        presenter.close()
    }
}

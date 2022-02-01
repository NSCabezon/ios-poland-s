//
//  ZusTransferSummaryViewControllerMock.swift
//  ZusTransfer_Example
//
//  Created by 187125 on 24/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Operative
import UI
import Commons
@testable import ZusTransfer

final class ZusTransferSummaryViewControllerMock: UIViewController, OperativeSummaryViewProtocol {
    var operativeSummaryStandardHeaderViewModel: OperativeSummaryStandardHeaderViewModel?
    var operativeSummaryStandardFooterItemViewModels: [OperativeSummaryStandardFooterItemViewModel]?
    var operativeSummaryStandardBodyItemViewModels: [OperativeSummaryStandardBodyItemViewModel]?
    var operativeSummaryStandardBodyActionViewModels: [OperativeSummaryStandardBodyActionViewModel]?
    var operativePresenter: OperativeStepPresenterProtocol
    var setupStandardFooterWithTitleCalled = false
    var setupStandardHeaderCalled = false
    var setupStandardBodyCalled = false
    var buildCalled = false
    
    init(presenter: ZusTransferSummaryPresenterProtocol) {
        self.operativePresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupStandardFooterWithTitle(_ title: String, items: [OperativeSummaryStandardFooterItemViewModel]) {
        setupStandardFooterWithTitleCalled = true
        operativeSummaryStandardFooterItemViewModels = items
    }
    
    func setupStandardHeader(with viewModel: OperativeSummaryStandardHeaderViewModel) {
        setupStandardHeaderCalled = true
        operativeSummaryStandardHeaderViewModel = viewModel
    }
    
    func setupStandardBody(withItems viewModels: [OperativeSummaryStandardBodyItemViewModel], actions: [OperativeSummaryStandardBodyActionViewModel], collapsableSections: SummaryCollapsable) {
        setupStandardBodyCalled = true
        operativeSummaryStandardBodyItemViewModels = viewModels
        operativeSummaryStandardBodyActionViewModels = actions
    }
    
    func build() {
        buildCalled = true
    }
    
    func setupStandardBody(withItems viewModels: [OperativeSummaryStandardBodyItemViewModel], locations: [OperativeSummaryStandardLocationViewModel], actions: [OperativeSummaryStandardBodyActionViewModel], collapsableSections: SummaryCollapsable) {}
    
    func resetContent() {}
}

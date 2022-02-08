//
//  CreditCardRepaymentSummaryViewMock.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 21/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import CoreFoundationLib
@testable import CreditCardRepayment
import Operative

final class CreditCardRepaymentSummaryViewMock: OperativeSummaryViewProtocol {
    // Operative
    var associatedViewController = UIViewController()
    var operativePresenter: OperativeStepPresenterProtocol
    var title: String?
    var associatedOldDialogView = UIViewController()
    var progressBarBackgroundColor: UIColor = .clear
    
    // Mock
    var headerViewModel: OperativeSummaryStandardHeaderViewModel = .init(image: "", title: "", description: "")
    var bodyViewModels: [OperativeSummaryStandardBodyItemViewModel] = []
    var footerTitle: String = ""
    var footerViewModels: [OperativeSummaryStandardFooterItemViewModel] = []
    var collapsableSections: SummaryCollapsable = .noCollapsable
    
    var didBuildCall: Bool = false
    var didResetCall: Bool = true

    func setupStandardFooterWithTitle(_ title: String, items: [OperativeSummaryStandardFooterItemViewModel]) {
        footerTitle = title
        footerViewModels = items
    }
    
    func setupStandardHeader(with viewModel: OperativeSummaryStandardHeaderViewModel) {
        headerViewModel = viewModel
    }
    
    func setupStandardBody(withItems viewModels: [OperativeSummaryStandardBodyItemViewModel], actions: [OperativeSummaryStandardBodyActionViewModel], collapsableSections: SummaryCollapsable) {
        bodyViewModels = viewModels
        self.collapsableSections = collapsableSections
    }
    
    func setupStandardBody(withItems viewModels: [OperativeSummaryStandardBodyItemViewModel], locations: [OperativeSummaryStandardLocationViewModel], actions: [OperativeSummaryStandardBodyActionViewModel], collapsableSections: SummaryCollapsable) {
        bodyViewModels = viewModels
        self.collapsableSections = collapsableSections
    }
    
    func build() {
        didBuildCall = true
    }
    
    func resetContent() {
        didResetCall = true
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.operativePresenter = dependenciesResolver.resolve(for: CreditCardRepaymentSummaryPresenterProtocol.self)
    }
    
}

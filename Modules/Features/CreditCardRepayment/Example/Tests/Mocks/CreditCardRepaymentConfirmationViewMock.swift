//
//  CreditCardRepaymentConfirmationViewMock.swift
//  CreditCardRepayment_Tests
//
//  Created by 186484 on 02/09/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import CoreFoundationLib
import Operative
@testable import CreditCardRepayment

final class CreditCardRepaymentConfirmationViewMock: CreditCardRepaymentConfirmationViewProtocol {
    
    // Operative
    var associatedViewController = UIViewController()
    var operativePresenter: OperativeStepPresenterProtocol
    var title: String?
    var associatedOldDialogView = UIViewController()
    var progressBarBackgroundColor: UIColor = .clear
    
    // Mock
    var isBackButtonEnabled: Bool = false
    var isCancelButtonEnabled: Bool = false
    
    var items: [ConfirmationItemViewModel] = []
    
    var headerViewModel: OperativeSummaryStandardHeaderViewModel = .init(image: "", title: "", description: "")
    var bodyViewModels: [OperativeSummaryStandardBodyItemViewModel] = []
    var footerTitle: String = ""
    var footerViewModels: [OperativeSummaryStandardFooterItemViewModel] = []
    
    var didBuildCall: Bool = false
    var didResetCall: Bool = true
    
    var onShowErrorDialog: () -> Void = {}

    func setupStandardFooterWithTitle(_ title: String, items: [OperativeSummaryStandardFooterItemViewModel]) {
        footerTitle = title
        footerViewModels = items
    }
    
    func setupStandardHeader(with viewModel: OperativeSummaryStandardHeaderViewModel) {
        headerViewModel = viewModel
    }
    
    func setupStandardBody(withItems viewModels: [OperativeSummaryStandardBodyItemViewModel], actions: [OperativeSummaryStandardBodyActionViewModel]) {
        bodyViewModels = viewModels
    }
    
    func setupStandardBody(withItems viewModels: [OperativeSummaryStandardBodyItemViewModel], locations: [OperativeSummaryStandardLocationViewModel], actions: [OperativeSummaryStandardBodyActionViewModel]) {
        bodyViewModels = viewModels
    }
    
    func build() {
        didBuildCall = true
    }
    
    func resetContent() {
        didResetCall = true
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.operativePresenter = dependenciesResolver.resolve(for: CreditCardRepaymentConfirmationPresenterProtocol.self)
    }
    
}

extension CreditCardRepaymentConfirmationViewMock {
    
    func showErrorDialog() {
        onShowErrorDialog()
    }
    
    func add(_ confirmationItems: [ConfirmationItemViewModel]) {
        items = confirmationItems
    }
    
    func add(_ confirmationItem: ConfirmationItemViewModel) { }
    func add(_ totalViewItem: ConfirmationTotalOperationItemViewModel) { }
    func add(_ containerItem: ConfirmationContainerViewModel) { }
    func add(_ containerView: UIView) { }
    func add(_ containerViews: [UIView]) { }
    func setContinueTitle(_ text: String) { }
}

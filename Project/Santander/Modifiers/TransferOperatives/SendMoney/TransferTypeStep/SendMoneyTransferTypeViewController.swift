//
//  SendMoneyTransferTypeViewController.swift
//  TransferOperatives
//
//  Created by José Norberto Hidalgo on 29/9/21.
//

import UI
import UIKit
import Operative
import UIOneComponents
import Models
import Commons

protocol SendMoneyTransferTypeView: OperativeView {
    func showTransferTypes(viewModel: OneCardSelectedAccountViewModel)
}

final class SendMoneyTransferTypeViewController: UIViewController {
    
    let presenter: SendMoneyTransferTypePresenterProtocol
    @IBOutlet private weak var floatingButton: FloatingButton!
    @IBOutlet private weak var floatingButtonConstraint: NSLayoutConstraint!
    
    init(presenter: SendMoneyTransferTypePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "SendMoneyTransferTypeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
        self.setupNavigationBar()
        self.presenter.viewDidLoad()
    }
}

private extension SendMoneyTransferTypeViewController {
    func setupNavigationBar() {
        OneNavigationBarBuilder(.whiteWithRedComponents)
            .setTitle(withKey: "toolbar_title_recipients")
            .setLeftAction(.back, customAction: self.didTapBack)
            .setRightAction(.help) {
                // TODO
            }
            .setRightAction(.close) {
                // TODO
            }
            .build(on: self)
    }
    
    func didTapBack() {
        self.presenter.back()
    }
    
    func setupComponents() {
        self.floatingButton.configureWith(
            type: .secondary,
            size: .large(
                FloatingButton.ButtonSize.LargeButtonConfig(title: localized("generic_button_continue"),
                                                            subtitle: self.presenter.getSubtitleInfo(),
                                                            icons: .right, fullWidth: false)),
            status: .ready)
        self.floatingButton.isEnabled = false
    }
}

extension SendMoneyTransferTypeViewController: SendMoneyTransferTypeView {
    var operativePresenter: OperativeStepPresenterProtocol {
        return self.presenter
    }
    
    func showTransferTypes(viewModel: OneCardSelectedAccountViewModel) {
        //TODO
    }
}

extension SendMoneyTransferTypeViewController: OneCardSelectedAccountDelegate {
    func didSelectOriginButton() {
        self.presenter.back()
    }
    
    func didSelectDestinationButton() { }
}

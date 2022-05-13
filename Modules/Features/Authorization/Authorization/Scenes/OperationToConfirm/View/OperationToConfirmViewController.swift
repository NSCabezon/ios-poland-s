//
//  OperationToConfirmViewController.swift
//  Authorization
//
//  Created by 186484 on 14/04/2022.
//

import Operative
import UI
import PLUI
import PLCommons
import CoreFoundationLib

protocol OperationToConfirmViewProtocol: AnyObject,
                                        LoaderPresentable,
                                        ErrorPresentable {
    
    func startProgressAnimation(totalDuration: TimeInterval, remainingDuration: TimeInterval)
    func updateCounter(remainingSeconds: Int)
    func handleTimerEndsProcess()
    
}

final class OperationToConfirmViewController: UIViewController {
    private let presenter: OperationToConfirmPresenterProtocol
    private lazy var contentView = OperationToConfirmView()
    
    init(presenter: OperationToConfirmPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func setUp() {
        hideKeyboardWhenTappedAround()
        prepareNavigationBar()
        prepareActions()
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .title(key: localized("toolbar_title_mobileAuthorization")))
            .setLeftAction(.back(action: .closure(didSelectGoBack)))
            .setRightActions(.close(action: .closure(didSelectCloseProcess)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    // MARK: - Actions
    
    func prepareActions() {
        contentView.onCancelTapped = { [weak self] in
            self?.didSelectCloseProcess()
        }
        
        contentView.onConfirmTapped = { [weak self] in
            self?.presenter.didSelectConfirmProcess()
        }
    }
    
    @objc func didSelectGoBack() {
        presenter.didSelectGoBack()
    }
    
    @objc func didSelectCloseProcess() {
        let dialog = AuthorizationDialogFactory.makeCloseDialog(
            onAccept: { [weak self] in
                self?.presenter.didSelectCloseProcess()
            }
        )
        dialog.showIn(self)
    }
    
    // MARK: - Dialogs
    private func prepareSuccessOperationDialog() {
        let dialog = AuthorizationDialogFactory.makeSuccessDialog(
            onAccept: { [weak self] in
                self?.presenter.didSelectCloseProcess()
            }
        )
        dialog.showIn(self)
    }
    
    private func prepareErrorOperationDialog() {
        let dialog = AuthorizationDialogFactory.makeErrorDialog(
            onAccept: { [weak self] in
                self?.presenter.didSelectCloseProcess()
            }
        )
        dialog.showIn(self)
    }
    
}

extension OperationToConfirmViewController: OperationToConfirmViewProtocol {
    
    func startProgressAnimation(totalDuration: TimeInterval, remainingDuration: TimeInterval) {
        contentView.startProgressBarAnimation(totalDuration: totalDuration, remainingDuration: remainingDuration)
        contentView.setRemainingSeconds(Int(remainingDuration))
    }
    
    func updateCounter(remainingSeconds: Int) {
        contentView.setRemainingSeconds(remainingSeconds)
    }
    
    func handleTimerEndsProcess() {
        let dialog = AuthorizationDialogFactory.makeTimeIsUpDialog(
            onAccept: { [weak self] in
                self?.presenter.didSelectCloseProcess()
            }
        )
        dialog.showIn(self)
    }
}

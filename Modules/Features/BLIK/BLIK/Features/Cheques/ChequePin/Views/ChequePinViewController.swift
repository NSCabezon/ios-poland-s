//
//  ChequePinViewController.swift
//  Santander
//
//  Created by 186491 on 31/05/2021.
//

import UIKit
import UI
import CoreFoundationLib
import PLUI
import PLCommons

protocol ChequePinViewProtocol: DialogViewPresentationCapable, SnackbarPresentable, LoaderPresentable {
    var pin: String { get }
    var pinConfirmation: String { get }
    func set(confirmationVisibility: ChequePinConfirmationFieldVisibility)
}

final class ChequePinViewController: UIViewController {
    private lazy var chequePinView = makeChequePinView()
    private let presenter: ChequePinPresenterProtocol
    
    init(
        presenter: ChequePinPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = chequePinView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "PIN do czeków BLIK"))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.close()
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _ = chequePinView.pinInput.becomeFirstResponder()
    }
}

extension ChequePinViewController: ChequePinViewProtocol {
    
    var pin: String {
        chequePinView.pinInput.pin
    }
    
    var pinConfirmation: String {
        chequePinView.pinConfirmationInput.pin
    }
    
    func set(confirmationVisibility: ChequePinConfirmationFieldVisibility) {
        switch confirmationVisibility {
        case .visible:
            chequePinView.pinConfirmationLabel.isHidden = false
            chequePinView.pinConfirmationInput.isHidden = false
        case .hidden:
            chequePinView.pinConfirmationLabel.isHidden = true
            chequePinView.pinConfirmationInput.isHidden = true
        }
    }
}

private extension ChequePinViewController {
    func makeChequePinView() -> ChequePinView {
        let view = ChequePinView()
        view.saveButtonOnTap = { [weak self] in
            self?.presenter.didPressSave()
        }
        return view
    }
    
    func setUp() {
        view.backgroundColor = .white
        chequePinView.pinInput.delegate = self
        chequePinView.pinConfirmationInput.delegate = self
        chequePinView.footerView.disableButton()
        configureNavigationItem()
        configureKeyboardDismissGesture()
    }
}

extension ChequePinViewController: PinInputViewDelegte {
    func pinInputViewDidFinishEdit(_ view: PinInputView) {
        if view == chequePinView.pinInput {
            set(confirmationVisibility: .visible)
        }
    }
    
    func didUpdateField() {
        let areFieldsFullyFilled =
            chequePinView.pinInput.isInputFullyFilled &&
            chequePinView.pinConfirmationInput.isInputFullyFilled
        
        if areFieldsFullyFilled {
            chequePinView.footerView.enableButton()
        } else {
            chequePinView.footerView.disableButton()
        }
    }
}

//
//  PhoneTopUpFormViewController.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/11/2021.
//

import UI
import PLUI
import Commons

protocol PhoneTopUpFormViewProtocol: AnyObject, ConfirmationDialogPresentable {
}

final class PhoneTopUpFormViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .santanderRed
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}

extension PhoneTopUpFormViewController: PhoneTopUpFormViewProtocol {
}

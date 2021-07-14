//
//  PLDialogTime.swift
//  Account
//
//  Created by Juan Sánchez Marín on 29/6/21.
//

import UIKit
import Commons
import UI
import Models

public struct PLDialogTime {
    let dateTimeStamp: Double

    public init(dateTimeStamp: Double) {
        self.dateTimeStamp = dateTimeStamp
    }

    public func show(in viewController: UIViewController) {
        let dialogViewController = PLTimerDialogViewController(with: self, nibName: "PLTimerDialogViewController", bundle: .module)
        dialogViewController.modalPresentationStyle = .overCurrentContext
        dialogViewController.modalTransitionStyle = .crossDissolve
        viewController.present(dialogViewController, animated: true, completion: nil)
    }
}

class PLTimerDialogViewController: UIViewController {
    private let dialog: PLDialogTime
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    var countTimer:Timer!
    var now: Date!
    var dateTimeStamp: Double = 0

    init(with dialog: PLDialogTime, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.dialog = dialog
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

        self.dateTimeStamp = self.dialog.dateTimeStamp
        self.now = Date()

        self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                                      target: self,
                                                      selector: #selector(self.updateText),
                                                      userInfo: nil,
                                                      repeats: true)
        self.contentView.isHidden = false
    }

    // MARK: - Private
    
    @objc private func updateText() {
        if self.dateTimeStamp > 0 {
            let date = Date(timeIntervalSince1970: self.dateTimeStamp)
            guard date > now else { return }
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]

            var minutes = formatter.string(from: self.now, to: date) ?? "00:00"

            switch minutes.count {
            case 1:
                minutes = "00:0\(minutes)"
                break
            case 2:
                minutes = "00:\(minutes)"
                break
            case 4:
                minutes = "0\(minutes)"
                break
            default:
                break
            }

            let text = localized("pl_login_alert_tryAgain", [StringPlaceholder(.value, minutes)])
            self.textLabel.text = text.plainText
            self.dateTimeStamp -= 1
        }
        else {
            countTimer.invalidate()
        }
    }

    private func setupView() {
        self.contentView.isHidden = true
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.masksToBounds = true
        self.textLabel.text = localized("pl_login_alert_tryAgain", [StringPlaceholder(.value, "00:00")]).plainText
        self.textLabel.textColor = .black
        self.textLabel.textAlignment = .center
        self.textLabel.font = .santander(family: .text, type: .regular, size: 16)
        self.bottomButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        self.bottomButton.clipsToBounds = true
        self.bottomButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 16)
        self.bottomButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonSelected)))
        self.bottomButton.accessibilityIdentifier = AccessibilityOthers.btnSend.rawValue
        self.bottomButton.setTitle(localized("generic_button_understand"), for: .normal)
    }

    @objc private func buttonSelected() {
        self.dismiss(animated: true)
    }
}
//
//  FloatingButtonController.swift
//  Santander
//
//  Created by 185998 on 18/03/2022.
//

import UIKit
import UI
import CoreFoundationLib

final class FloatingButtonController: UIViewController {
    private(set) var button: UIButton?
    private(set) var buttonLabel: UIButton?
    private(set) var buttonsContainderView = UIView()
    
    private weak var window: FloatingButtonWindow?
    private let onStopBlock: () -> Void
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(
        window: FloatingButtonWindow,
        onStopBlock: @escaping () -> Void
    ) {
        self.window = window
        self.onStopBlock = onStopBlock
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLayoutSubviews() {
        guard
            let button = button,
            let buttonLabel = buttonLabel
        else {
            return
        }
        button.layer.cornerRadius = button.frame.size.height / 2
        buttonLabel.layer.cornerRadius = buttonLabel.frame.size.height / 2
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(note:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
    }
    
    private func makeButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .bostonRed
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 10, right: 12)
        button.setImage(UIImage(named: "stopScreenSharingButtonImage"), for: .normal)
        button.sizeToFit()
        button.drawShadow(offset: (x: 1, y: 2), opacity: 1, color: .coolGray, radius: 3)
        return button
    }
    
    private func makeButtonLabel() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.setTitleColor(.bostonRed, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        button.setTitle(localized("pl_onlineAdvisor_button_stopSharing"), for: .normal)
        button.titleLabel?.font = .santanderTextBold(size: 14)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.drawShadow(offset: (x: 1, y: 2), opacity: 1, color: .coolGray, radius: 3)
        return button
    }
    
    private func setButtonsConstraints() {
        guard
            let button = button,
            let buttonLabel = buttonLabel
        else {
            return
        }
        
        buttonsContainderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsContainderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            buttonsContainderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 64),
            button.widthAnchor.constraint(equalToConstant: 64),
            button.topAnchor.constraint(equalTo: buttonsContainderView.topAnchor, constant: 0),
            button.centerXAnchor.constraint(equalTo: buttonsContainderView.centerXAnchor)
        ])
        
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonLabel.heightAnchor.constraint(equalToConstant: 32),
            buttonLabel.centerXAnchor.constraint(equalTo: buttonsContainderView.centerXAnchor),
            buttonLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 22),
            buttonLabel.bottomAnchor.constraint(equalTo: buttonsContainderView.bottomAnchor, constant: 0),
            buttonLabel.trailingAnchor.constraint(equalTo: buttonsContainderView.trailingAnchor, constant: 0),
            buttonLabel.leadingAnchor.constraint(equalTo: buttonsContainderView.leadingAnchor, constant: 0)
        ])
        
    }
    override func loadView() {
        self.view = UIView()
        buttonsContainderView.backgroundColor = .clear
        let button = makeButton()
        let buttonLabel = makeButtonLabel()
        
        self.button = button
        self.buttonLabel = buttonLabel

        buttonsContainderView.addSubview(button)
        buttonsContainderView.addSubview(buttonLabel)
        view.addSubview(buttonsContainderView)
        setButtonsConstraints()
        
        let panner = UIPanGestureRecognizer(
            target: self,
            action: #selector(panDidFire(panner:))
        )
        buttonsContainderView.addGestureRecognizer(panner)

        button.addTarget(
            self,
            action: #selector(onStopHandler),
            for: .touchUpInside
        )
        buttonLabel.addTarget(
            self,
            action: #selector(onStopHandler),
            for: .touchUpInside
        )
        setupStatusBarBackground()
    }

    @objc private func onStopHandler() {
        onStopBlock()
    }

    private func setupStatusBarBackground() {
        guard #available(iOS 13.0, *) else {
            let statusBar = UIApplication.shared.value(
                forKeyPath: "statusBarWindow.statusBar"
            ) as? UIView
            statusBar?.backgroundColor = UIColor.red
            return
        }

        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height

        let statusbarView = UIView()
        statusbarView.backgroundColor = UIColor.red
        view.addSubview(statusbarView)

        statusbarView.translatesAutoresizingMaskIntoConstraints = false
        statusbarView.heightAnchor.constraint(equalToConstant: statusBarHeight).isActive = true
        statusbarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        statusbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        statusbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        var center = buttonsContainderView.center
        center.x += offset.x
        center.y += offset.y
        buttonsContainderView.center = center
    }

    @objc func keyboardDidShow(note: NSNotification) {
        window?.windowLevel = UIWindow.Level(rawValue: 0)
        window?.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
    }
}

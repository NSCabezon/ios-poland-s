//
//  TaxTransferFormViewController.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

import Commons
import PLCommons
import UI
import PLUI

protocol TaxTransferFormView: AnyObject, LoaderPresentable {
    func disableDoneButton(with messages: TaxTransferFormValidity.InvalidFormMessages)
    func enableDoneButton()
}

final class TaxTransferFormViewController: UIViewController {
    private let presenter: TaxTransferFormPresenterProtocol
    internal let keyboardManager = KeyboardManager()
    private let scrollView = UIScrollView()
    private let bottomButtonView = BottomButtonView()
    private lazy var formView = TaxTransferFormContainerView(
        configuration: presenter.getTaxFormConfiguration(),
        delegate: self
    )
    
    
    init(presenter: TaxTransferFormPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension TaxTransferFormViewController: TaxTransferFormView {
    func disableDoneButton(with messages: TaxTransferFormValidity.InvalidFormMessages) {
        bottomButtonView.disableButton()
        formView.setInvalidFormMessages(messages)
    }
    
    func enableDoneButton() {
        bottomButtonView.enableButton()
        formView.clearInvalidFormMessages()
    }
}

private extension TaxTransferFormViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureBottomView()
        configureKeyboardManager()
        configureStyling()
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "#Przelew podatkowy"))
            .setLeftAction(.back(action: #selector(back)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func back() {
         presenter.didTapBack()
    }
    
    func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(formView)
        view.addSubview(bottomButtonView)
        
        [scrollView, formView, bottomButtonView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            formView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            formView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            formView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            formView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bottomButtonView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureKeyboardManager() {
        keyboardManager.setDelegate(self)
        keyboardManager.update()
    }
    
    func configureBottomView() {
        bottomButtonView.disableButton()
        bottomButtonView.configure(title: "#Gotowe") { [weak self] in
            guard let data = self?.formView.getFormFieldsData() else { return }
            self?.presenter.didTapDone(with: data)
        }
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
}

extension TaxTransferFormViewController: KeyboardManagerDelegate {
    var associatedScrollView: UIScrollView? {
        return scrollView
    }
}

extension TaxTransferFormViewController: TaxTransferFormContainerViewDelegate {
    func scrollToBottom() {
        let bottomOffset = CGPoint(
            x: 0,
            y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom
        )
        if (bottomOffset.y > 0) {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func didUpdateFields(withData data: TaxTransferFormFieldsData) {
        presenter.didUpdateFields(with: data)
    }
}
//
//  AddTaxAuthorityViewController.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import UI
import PLUI

final class AddTaxAuthorityViewController: UIViewController {
    private let presenter: AddTaxAuthorityPresenterProtocol
    private let scrollView = UIScrollView()
    private let bottomButtonView = BottomButtonView()
    private lazy var formView = AddTaxAuthorityContainerView(
        delegate: self
    )
    
    let keyboardManager = KeyboardManager()

    init(presenter: AddTaxAuthorityPresenterProtocol) {
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
        presenter.viewDidLoad()
    }
}

private extension AddTaxAuthorityViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureBottomView()
        configureKeyboardManager()
        configureStyling()
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "#Odbiorca/ aka Organ Podatkowy"))
            .setLeftAction(.back(action: .selector(#selector(back))))
            .setRightActions(.close(action: .selector(#selector(close))))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
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
        bottomButtonView.configure(title: "#Gotowe") {
            // TODO:- Configure bottom button action
        }
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    @objc func back() {
         presenter.didTapBack()
    }
    
    @objc func close() {
        presenter.didTapClose()
    }
}

extension AddTaxAuthorityViewController: KeyboardManagerDelegate {
    var associatedScrollView: UIScrollView? {
        return scrollView
    }
}

extension AddTaxAuthorityViewController: AddTaxAuthorityContainerViewDelegate {
    func didUpdateFields() {
        // TODO:- Update delegate interface
    }
}


//
//  DeleteAliasViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 06/09/2021.
//

import CoreFoundationLib
import UI
import PLUI
import PLCommons

protocol DeleteAliasView: AnyObject, LoaderPresentable, ErrorPresentable {}

final class DeleteAliasViewController: UIViewController, DeleteAliasView {
    private let presenter: DeleteAliasPresenterProtocol
    private let viewModel: DeleteAliasViewModel
    private let contentView = DeleteAliasContentView()
    private let bottomButton = BottomButtonView()
    
    init(
        presenter: DeleteAliasPresenterProtocol,
        viewModel: DeleteAliasViewModel
    ) {
        self.presenter = presenter
        self.viewModel = viewModel
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

private extension DeleteAliasViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureBottomButton()
        configureStyling()
        contentView.setViewModel(viewModel)
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: viewModel.screenTitle))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
    
    func configureSubviews() {
        [contentView, bottomButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomButton.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    func configureBottomButton() {
        bottomButton.configure(title: localized("pl_blik_button_delete"), action: { [weak self] in
            guard let strongSelf = self else { return }
            let deletionReason: DeleteAliasReason = {
                if strongSelf.contentView.didCheckFraudTransactionCheckbox {
                    return .someoneDidPerformFraudTransactionWithAlias
                } else {
                    return .unknown
                }
            }()
            strongSelf.presenter.didPressDelete(deletionReason: deletionReason)
        })
    }
}

//
//  TaxTransferAccountSelectorView.swift
//  TaxTransfer
//
//  Created by 185167 on 13/12/2021.
//

import PLUI

final class TaxTransferAccountSelectorView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let accountView = SelectedAccountView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(
        with viewModel: TaxTransferFormViewModel.SelectedAccount,
        onTap: @escaping () -> Void
    ) {
        accountView.setChangeAction(onTap)
        accountView.setViewModel(mapViewModels(from: viewModel))
    }
}

private extension TaxTransferAccountSelectorView {
    func setUp() {
        configureSubviews()
        
        // TODO:- Remove after hooking up data with presenter
        configure(with:
            .init(
                accountName: "Konto dla Ciebie",
                maskedAccountNumber: "*1234",
                unformattedAccountNumber: "",
                accountBalance: "96,73 PLN",
                isOnlyAccount: false
            ),
            onTap: {}
        )
        //
    }
    
    func configureSubviews() {
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: accountView,
            sectionTitle: "#Konto, z którego robisz przelew"
        )
    }
    
    func mapViewModels(from viewModel: TaxTransferFormViewModel.SelectedAccount) -> [SelectableAccountViewModel] {
        let mappedViewModel = SelectableAccountViewModel(
            name: viewModel.accountName,
            accountNumber: viewModel.maskedAccountNumber,
            accountNumberUnformatted: viewModel.unformattedAccountNumber,
            availableFunds: viewModel.accountBalance,
            isSelected: true
        )
        if viewModel.isOnlyAccount {
            return [mappedViewModel]
        }
        
        // There is additional dummy viewModel in order for `SelectedAccountView` to display edit button
        return [
            mappedViewModel,
            SelectableAccountViewModel(
                name: "",
                accountNumber: "",
                accountNumberUnformatted: "",
                availableFunds: "",
                isSelected: false
            ),
        ]
    }
}

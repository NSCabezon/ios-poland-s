//
//  TaxAuthoritySelectorCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 10/03/2022.
//

import CoreFoundationLib
import PLScenes
import UI
import PLUI
import PLCommons

protocol TaxAuthoritySelectorCoordinatorProtocol: ModuleCoordinator {}

final class TaxAuthoritySelectorCoordinator: TaxAuthoritySelectorCoordinatorProtocol  {
    weak var navigationController: UINavigationController?
    
    private let dependenciesEngine: DependenciesDefault
    private let taxAuthorities: [TaxAuthority]
    private let selectedTaxAuthority: TaxAuthority?
    
    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        taxAuthorities: [TaxAuthority],
        selectedTaxAuthority: TaxAuthority?
    ) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.taxAuthorities = taxAuthorities
        self.selectedTaxAuthority = selectedTaxAuthority
        setUpDependencies()
    }
    
    func start() {
        if taxAuthorities.isEmpty {
            showTaxAuthorityForm()
        } else {
            showTaxAuthorityList()
        }
    }
}

private extension TaxAuthoritySelectorCoordinator {
    func showTaxAuthorityList() {
        let viewModelMapper = SelectableTaxAuthorityViewModelMapper()
        let itemsViewModels = taxAuthorities.map { viewModelMapper.map($0, selectedTaxAuthority: selectedTaxAuthority) }
        let selectedItemViewModel: SelectableTaxAuthorityViewModel? = {
            guard let taxAuthority = selectedTaxAuthority else { return nil }
            return viewModelMapper.map(taxAuthority, selectedTaxAuthority: selectedTaxAuthority)
        }()
        let configuration = TaxTransferParticipantConfiguration<SelectableTaxAuthorityViewModel>(
            shouldBackAfterSelectItem: true,
            taxItemSelectorType: .payee,
            items: itemsViewModels,
            selectedItem: selectedItemViewModel
        )
        let taxItemSelectorCoordinator = TaxTransferParticipantSelectorCoordinator<SelectableTaxAuthorityViewModel>(
            configuration: configuration,
            itemSelectionHandler: handlePredefinedTaxAuthoritySelection,
            buttonActionHandler: showTaxAuthorityForm,
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController
        )
        taxItemSelectorCoordinator.start()
    }
    
    func handlePredefinedTaxAuthoritySelection(
        with taxAuthorityViewModel: SelectableTaxAuthorityViewModel,
        in presenter: (LoaderPresentable & ConfirmationDialogPresentable)
    ) {
        presenter.showLoader()
        TaxAccountValidator(dependenciesResolver: dependenciesEngine).validateAccount(
            withNumber: taxAuthorityViewModel.taxAuthority.accountNumber,
            onValidResult: { [weak self] in
                presenter.hideLoader(completion: {
                    self?.handleValidPredefinedTaxAuthoritySelection(taxAuthorityViewModel.taxAuthority)
                })
            },
            onInvalidResult: { [weak self] in
                presenter.hideLoader(completion: {
                    self?.showInvalidTaxAccountDialog(in: presenter)
                })
            },
            onError: { [weak self] _ in
                presenter.hideLoader(completion: {
                    self?.showInvalidTaxAccountDialog(in: presenter)
                })
            }
        )
    }
    
    func handleValidPredefinedTaxAuthoritySelection(_ taxAuthority: TaxAuthority) {
        let isSelectedAuthorityEqualToSelectedInTransferForm = (selectedTaxAuthority == taxAuthority)

        if isSelectedAuthorityEqualToSelectedInTransferForm {
            showTaxAuthorityForm(withContext: .didSelectTaxAuthorityInTransferForm(taxAuthority))
        } else {
            showTaxAuthorityForm(withContext: .didSelectTaxAuthorityInPredefinedList(taxAuthority))
        }
    }
    
    func showTaxAuthorityForm() {
        if let selectedTaxAuthority = selectedTaxAuthority {
            showTaxAuthorityForm(withContext: .didSelectTaxAuthorityInTransferForm(selectedTaxAuthority))
        } else {
            showTaxAuthorityForm(withContext: .didNotPreselectAnyData)
        }
    }
    
    func showTaxAuthorityForm(withContext context: AddTaxAuthorityEntryPointContext) {
        let coordinator = AddTaxAuthorityCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            entryPointContext: context
        )
        coordinator.start()
    }
    
    // TODO:- Replace with generic LisboaDialog wrapper implemented in other PR
    func showInvalidTaxAccountDialog(in presenter: ConfirmationDialogPresentable) {
        let image = LisboaDialogImageViewItem(image: PLAssets.image(named: "info_blueGreen"), size: (50, 50))
        let buttonTitle = LocalizedStylableText(text: localized("generic_link_ok"), styles: nil)
        
        let items: [LisboaDialogItem] = [
            .margin(25),
            .image(image),
            .margin(12),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("#Informacja"),
                    font: .santander(family: .micro, type: .bold, size: 28),
                    color: .black,
                    alignament: .center,
                    margins: (((0, 0)))
                )
            ),
            .margin(12),
            .styledText(
                LisboaDialogTextItem(
                    text: localized("Nie możesz wpłacić podatku na numer rachunku wybranego urzędu. Zaktualizuj numer rachunku - zaloguj się do Santander Internet i wejdź w zakładkę Przelewy / Lista odbiorców."),
                    font: .santander(family: .micro, type: .regular, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: (24, 24)
                )
            ),
            .margin(24),
            .verticalAction(
                VerticalLisboaDialogAction(
                    title: buttonTitle,
                    type: .red,
                    margins: (16, 16),
                    action: {}
                )
            ),
            .margin(16)
        ]
        
        let dialog = LisboaDialog(items: items, closeButtonAvailable: false)
        presenter.showDialog(dialog)
    }
    
    func setUpDependencies() {
        dependenciesEngine.register(for: TaxAccountMapping.self) { _ in
            return TaxAccountMapper(
                dateFormatter: PLTimeFormat.yyyyMMdd.createDateFormatter()
            )
        }
        
        dependenciesEngine.register(for: GetTaxAccountsUseCaseProtocol.self) { resolver in
            return GetTaxAccountsUseCase(dependenciesResolver: resolver)
        }
    }
}

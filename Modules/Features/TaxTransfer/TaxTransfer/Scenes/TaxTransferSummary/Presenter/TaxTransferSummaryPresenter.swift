//
//  TaxTransferSummaryPresenter.swift
//  TaxTransfer
//
//  Created by 187831 on 21/03/2022.
//

import CoreFoundationLib
import PLCommons
import Operative

protocol TaxTransferSummaryPresenterProtocol: OperativeSummaryPresenterProtocol {
    func close()
}

final class TaxTransferSummaryPresenter {
    var view: OperativeSummaryViewProtocol?
    
    // Implementation OperativeSummaryPresenterProtocol
    var number: Int = 0
    var container: OperativeContainerProtocol?
    var isBackButtonEnabled: Bool = false
    var isBackable: Bool = false
    var isCancelButtonEnabled: Bool = true
    
    private struct Constants {
        static var opinatorPath = "APP-RET-tax-payment-SUCCESS"
    }
    
    private let dependenciesResolver: DependenciesResolver
    private let transferModel: TaxTransferModel
    private let summaryModel: TaxTransferSummary
    
    init(dependenciesResolver: DependenciesResolver,
         transferModel: TaxTransferModel,
         summaryModel: TaxTransferSummary) {
        self.dependenciesResolver = dependenciesResolver
        self.summaryModel = summaryModel
        self.transferModel = transferModel
    }
    
    func viewDidLoad() {
        prepareViewModel()
        saveTransferDataInStorageIfNeeded()
    }
}

extension TaxTransferSummaryPresenter: TaxTransferSummaryPresenterProtocol {
    func close() {
        coordinator.goToGlobalPosition()
    }
}

private extension TaxTransferSummaryPresenter {
    var coordinator: TaxTransferSummaryCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    
    var mapper: TaxOperativeSummaryMapping {
        dependenciesResolver.resolve()
    }
    
    func prepareViewModel() {
        let headerViewModel = OperativeSummaryStandardHeaderViewModel(
            image: "icnCheckOval1",
            title: localized("generic_label_done"),
            description: localized("summary_label_amountOf")
        )
        
        let bodyItems = mapper.map(transferModel, summaryModel: summaryModel)
        
        let footerItems: [OperativeSummaryStandardFooterItemViewModel] = [
            .init(imageKey: "icnEnviarDinero", title: localized("generic_button_anotherPayment"), action: { [weak self] in
                self?.coordinator.goToMakeAnotherPayment()
            }),
            .init(imageKey: "icnPg", title: localized("generic_button_globalPosition"), action: { [weak self] in
                self?.coordinator.goToGlobalPosition()
            }),
            .init(imageKey: "icnHelpUsMenu", title: localized("generic_button_improve"), action: { [weak self] in
                let opinator = RegularOpinatorInfoEntity(path: Constants.opinatorPath)
                let coordinator = self?.dependenciesResolver.resolve(for: OperativeContainerCoordinatorDelegate.self)
                coordinator?.handleOpinator(opinator)
            })
        ]
        
        let viewModel = OperativeSummaryStandardViewModel(
            header: headerViewModel,
            bodyItems: bodyItems,
            bodyActionItems: [],
            footerItems: footerItems
        )
        
        view?.setupStandardHeader(with: viewModel.header)
        view?.setupStandardBody(withItems: viewModel.bodyItems,
                                actions: viewModel.bodyActionItems,
                                collapsableSections: .defaultCollapsable(visibleSections: 3))
        view?.setupStandardFooterWithTitle(localized("summary_label_nowThat"), items: viewModel.footerItems)
        view?.build()
    }
    
    func saveTransferDataInStorageIfNeeded() {
        switch transferModel.taxAuthority {
        case let .usTaxAuthority(data):
            let storage = AddTaxAuthorityStorage()
            try? storage.saveLastSelectedCity(TaxAuthorityCity(cityName: data.cityName))
            try? storage.saveLastSelectedTaxAccountNumber(data.taxAuthorityAccount.accountNumber)
        case .irpTaxAuthority, .predefinedTaxAuthority:
            break
        }
    }
}

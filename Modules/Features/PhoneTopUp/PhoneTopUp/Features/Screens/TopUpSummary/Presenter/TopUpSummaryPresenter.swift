//
//  TopUpSummaryPresnter.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/01/2022.
//

import Commons
import PLCommons
import Operative
import CoreFoundationLib

protocol TopUpSummaryPresenterProtocol: OperativeSummaryPresenterProtocol {
    func didSelectClose()
}

final class TopUpSummaryPresenter {
    // MARK: Properties
    weak var view: OperativeSummaryViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: TopUpSummaryCoordinatorProtocol?
    private let summaryMapper: TopUpSummaryMapping
    private let summary: TopUpModel
    
    //These variables below are forced to be conformed to OperativeStepPresenterProtocol, we need to have it to display summary screen from core
    var number: Int = 0
    var container: OperativeContainerProtocol?
    var isBackButtonEnabled: Bool = false
    var isBackable: Bool = false
    var isCancelButtonEnabled: Bool = true
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver, summary: TopUpModel) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(for: TopUpSummaryCoordinatorProtocol.self)
        self.summaryMapper = dependenciesResolver.resolve(for: TopUpSummaryMapping.self)
        self.summary = summary
    }
}

extension TopUpSummaryPresenter: TopUpSummaryPresenterProtocol {
    func viewDidLoad() {
        prepareSummaryView()
    }
    
    func didSelectClose() {
        coordinator?.close()
    }
}

private extension TopUpSummaryPresenter {
    func prepareSummaryView() {
        let headerViewModel = OperativeSummaryStandardHeaderViewModel(image: "icnCheckOval1",
                                                                      title: localized("pl_topup_text_success"),
                                                                      description: localized("pl_topup_text_successExpl"))
        
        let bodyItems = summaryMapper.mapSuccessSummary(model: summary)
        
        let footerItems: [OperativeSummaryStandardFooterItemViewModel] = [
            .init(imageKey: "icnEnviarDinero", title: localized("pl_topup_button_anotherPayment"), action: { [weak self] in
                self?.coordinator?.makeAnotherTopUp()
            }),
            .init(imageKey: "icnPg", title: localized("generic_button_globalPosition"), action: { [weak self] in
                self?.coordinator?.goToGlobalPosition()
            }),
            .init(imageKey: "icnHelpUsMenu", title: localized("generic_button_improve"), action: { [weak self] in
                let opinator = RegularOpinatorInfoEntity(path: "APP-RET-blik-topup-SUCCESS")
                let coordinator = self?.dependenciesResolver.resolve(for: OperativeContainerCoordinatorDelegate.self)
                coordinator?.handleOpinator(opinator)
            })
        ]
        let viewModel = OperativeSummaryStandardViewModel(header: headerViewModel,
                                                          bodyItems: bodyItems,
                                                          bodyActionItems: [],
                                                          footerItems: footerItems)
        
        view?.setupStandardHeader(with: viewModel.header)
        view?.setupStandardBody(withItems: viewModel.bodyItems,
                                actions: viewModel.bodyActionItems,
                                collapsableSections: .defaultCollapsable(visibleSections: 3))
        view?.setupStandardFooterWithTitle(localized("footerSummary_label_andNow"), items: viewModel.footerItems)
        view?.build()
    }
}

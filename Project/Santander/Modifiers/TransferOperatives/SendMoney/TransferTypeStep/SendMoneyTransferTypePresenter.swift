//
//  SendMoneyTransferTypePresenter.swift
//  TransferOperatives
//
//  Created by José Norberto Hidalgo on 29/9/21.
//

import Operative
import Models
import Commons
import TransferOperatives

protocol SendMoneyTransferTypePresenterProtocol: OperativeStepPresenterProtocol {
    var view: SendMoneyTransferTypeView? { get set }
    func viewDidLoad()
    func back()
    func close()
    func getSubtitleInfo() -> String
}

final class SendMoneyTransferTypePresenter {
    var number: Int = 0
    var isBackButtonEnabled: Bool = true
    var isCancelButtonEnabled: Bool = true
    var container: OperativeContainerProtocol?
    weak var view: SendMoneyTransferTypeView?
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension SendMoneyTransferTypePresenter: SendMoneyTransferTypePresenterProtocol {
    func viewDidLoad() {
        // view?.showTransferTypes(viewModel: )
    }
    
    func back() {
        self.container?.back()
    }
    
    func close() {
        self.container?.close()
    }
    
    func getSubtitleInfo() -> String {
        self.container?.getSubtitleInfo(presenter: self) ?? ""
    }
}

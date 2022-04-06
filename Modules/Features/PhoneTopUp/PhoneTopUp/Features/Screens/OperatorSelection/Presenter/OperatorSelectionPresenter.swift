//
//  OperatorSelectionPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/01/2022.
//

import CoreFoundationLib
import PLCommons
import PLUI

protocol OperatorSelectionPresenterProtocol: AnyObject {
    var view: OperatorSelectionViewProtocol? { get set }
    func didSelectBack()
    func numberOfRows() -> Int
    func cellModel(for row: Int) -> OperatorSelectionCellViewModel
    func didSelectCell(at row: Int)
}

final class OperatorSelectionPresenter {
    // MARK: Properties
    
    weak var view: OperatorSelectionViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private weak var coordinator: OperatorSelectionCoordinatorProtocol?
    private var selectedOperatorId: Int?
    private let operators: [Operator]
    private var cellModels: [OperatorSelectionCellViewModel] {
        return operators.map { OperatorSelectionCellViewModel(gsmOperator: $0, isSelected: $0.id == selectedOperatorId) }
    }
    
    init(dependenciesResolver: DependenciesResolver,
         operators: [Operator],
         selectedOperatorId: Int?) {
        self.dependenciesResolver = dependenciesResolver
        coordinator = dependenciesResolver.resolve(for: OperatorSelectionCoordinatorProtocol.self)
        self.operators = operators
        self.selectedOperatorId = selectedOperatorId
    }
}

extension OperatorSelectionPresenter: OperatorSelectionPresenterProtocol {
    func numberOfRows() -> Int {
        return cellModels.count
    }
    
    func cellModel(for row: Int) -> OperatorSelectionCellViewModel {
        return cellModels[row]
    }
    
    func didSelectCell(at row: Int) {
        let selectedOperatorId = cellModels[row].operatorId
        guard let selectedOperator = operators.first(where: { $0.id == selectedOperatorId }) else {
            return
        }
        coordinator?.didSelectOperator(selectedOperator)
    }
    
    func didSelectBack() {
        coordinator?.back()
    }
}

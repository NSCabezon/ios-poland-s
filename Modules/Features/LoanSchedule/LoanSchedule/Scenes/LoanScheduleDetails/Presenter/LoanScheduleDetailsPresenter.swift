import CoreFoundationLib
import CoreFoundationLib
import UI

protocol LoanScheduleDetailsPresenterProtocol: MenuTextWrapperProtocol {
    var view: LoanScheduleDetailsViewProtocol? { get set }
    
    func viewDidLoad()
    func backButtonSelected()
}

final class LoanScheduleDetailsPresenter {
    weak var view: LoanScheduleDetailsViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private let item: LoanSchedule.ItemEntity
    
    init(dependenciesResolver: DependenciesResolver, loanScheduleItem: LoanSchedule.ItemEntity) {
        self.dependenciesResolver = dependenciesResolver
        self.item = loanScheduleItem
    }
}

private extension LoanScheduleDetailsPresenter {
    var coordinator: LoanScheduleDetailsCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: LoanScheduleDetailsCoordinatorProtocol.self)
    }
    
    var getGetLoanScheduleUseCase: GetLoanScheduleUseCaseProtocol {
        dependenciesResolver.resolve(for: GetLoanScheduleUseCaseProtocol.self)
    }
    
    var viewModelMapper: LoanScheduleDetailsViewModelMapping {
        dependenciesResolver.resolve(for: LoanScheduleDetailsViewModelMapping.self)
    }
}

extension LoanScheduleDetailsPresenter: LoanScheduleDetailsPresenterProtocol {
    
    func viewDidLoad() {
        setUpDetails()
    }
    
    func backButtonSelected() {
        coordinator.goBack()
    }
    
    private func setUpDetails() {
        let viewModel = viewModelMapper.map(item)
        view?.setUp(withViewModel: viewModel)
    }
}

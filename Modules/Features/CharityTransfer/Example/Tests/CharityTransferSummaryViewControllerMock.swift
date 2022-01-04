import Operative
import UI
import Commons
@testable import CharityTransfer

final class CharityTransferSummaryViewControllerMock: UIViewController, OperativeSummaryViewProtocol {
    var operativeSummaryStandardHeaderViewModel: OperativeSummaryStandardHeaderViewModel?
    var operativeSummaryStandardFooterItemViewModels: [OperativeSummaryStandardFooterItemViewModel]?
    var operativeSummaryStandardBodyItemViewModels: [OperativeSummaryStandardBodyItemViewModel]?
    var operativeSummaryStandardBodyActionViewModels: [OperativeSummaryStandardBodyActionViewModel]?
    var operativePresenter: OperativeStepPresenterProtocol
    var setupStandardFooterWithTitleCalled = false
    var setupStandardHeaderCalled = false
    var setupStandardBodyCalled = false
    var buildCalled = false
    
    
    init(presenter: CharityTransferSummaryPresenterProtocol) {
        self.operativePresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStandardFooterWithTitle(_ title: String, items: [OperativeSummaryStandardFooterItemViewModel]) {
        setupStandardFooterWithTitleCalled = true
        operativeSummaryStandardFooterItemViewModels = items
    }
    
    func setupStandardHeader(with viewModel: OperativeSummaryStandardHeaderViewModel) {
        setupStandardHeaderCalled = true
        operativeSummaryStandardHeaderViewModel = viewModel
    }
    
    func setupStandardBody(
        withItems viewModels: [OperativeSummaryStandardBodyItemViewModel],
        actions: [OperativeSummaryStandardBodyActionViewModel],
        collapsableSections: SummaryCollapsable
    ) {
        setupStandardBodyCalled = true
        operativeSummaryStandardBodyItemViewModels = viewModels
        operativeSummaryStandardBodyActionViewModels = actions
    }
    
    func build() {
        buildCalled = true
    }
    
    func resetContent() {}
    
    func setupStandardBody(
        withItems viewModels: [OperativeSummaryStandardBodyItemViewModel],
        locations: [OperativeSummaryStandardLocationViewModel],
        actions: [OperativeSummaryStandardBodyActionViewModel],
        collapsableSections: SummaryCollapsable
    ) {}
}


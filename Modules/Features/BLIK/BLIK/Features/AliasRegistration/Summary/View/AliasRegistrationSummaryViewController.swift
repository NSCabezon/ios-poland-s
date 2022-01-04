import Operative
import UI
import Commons
import PLCommons

final class AliasRegistrationSummaryViewController: OperativeSummaryViewController {
    private let presenter: AliasRegistrationSummaryPresenterProtocol
    private let registeredAliasType: Transaction.AliasProposalType
    
    init(
        presenter: AliasRegistrationSummaryPresenterProtocol,
        registeredAliasType: Transaction.AliasProposalType
    ) {
        self.presenter = presenter
        self.registeredAliasType = registeredAliasType
        super.init(presenter: presenter)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBody()
        setUpHeader()
        build()
    }
    
    override func setupNavigationBar() {
        let builder = NavigationBarBuilder(
            style: .sky,
            title: .title(key: "genericToolbar_title_summary")
        )
        builder.setRightActions(.close(action: #selector(close)))
        builder.build(on: self, with: nil)
    }
}

private extension AliasRegistrationSummaryViewController {
    @objc func close() {
        self.presenter.goToGlobalPosition()
    }
    
    func setUpBody() {
        let view = AliasRegistrationSummaryView()
        view.setInfoText(getInfoText())
        view.translatesAutoresizingMaskIntoConstraints = false
        setupBody(view)
    }
    
    func setUpHeader() {
        let viewModel = OperativeSummaryStandardHeaderViewModel(image: "icnCheckOval1",
                                                                title: localized("pl_blik_text_success"),
                                                                description: getHeaderText())
        setupStandardHeader(with: viewModel)
    }
    
    func getInfoText() -> String {
        switch registeredAliasType {
        case .cookie:
            return localized("pl_blik_text_saveBrowserSuccessText")
        case .uid:
            return localized("pl_blik_text_saveShopSuccessText")
        }
    }
    
    func getHeaderText() -> String {
        switch registeredAliasType {
        case .cookie:
            return localized("pl_blik_text_saveBrowserSuccess")
        case .uid:
            return localized("pl_blik_text_saveShopSuccess")
        }
    }
}

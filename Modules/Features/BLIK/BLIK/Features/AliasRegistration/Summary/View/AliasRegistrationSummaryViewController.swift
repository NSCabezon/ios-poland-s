import Operative
import UI
import Commons

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
    
    func getInfoText() -> String {
        switch registeredAliasType {
        case .cookie:
            return "#Przeglądarka została zapamiętana. Przy następnych zakupach na tej przeglądarce nie będziesz musiał wpisywać kodu BLIK."
        case .uid:
            return "#Sklep został zapamiętany. Przy następnych zakupach w tym sklepie nie będziesz musiał wpisywać kodu BLIK."
        }
    }
}

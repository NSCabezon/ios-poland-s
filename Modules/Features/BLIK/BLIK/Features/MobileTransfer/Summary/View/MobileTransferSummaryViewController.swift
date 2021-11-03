import Operative
import UI
import Commons

final class MobileTransferSummaryViewController: OperativeSummaryViewController {
    private let presenter: MobileTransferSummaryPresenterProtocol
    
    init(presenter: MobileTransferSummaryPresenterProtocol) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationBar() {
        let builder = NavigationBarBuilder(style: .sky, title: .title(key: "genericToolbar_title_summary"))
        builder.setRightActions(.close(action: #selector(close)))
        builder.build(on: self, with: nil)
    }
}

private extension MobileTransferSummaryViewController {
    @objc func close() {
        self.presenter.goToBlikCode()
    }
}

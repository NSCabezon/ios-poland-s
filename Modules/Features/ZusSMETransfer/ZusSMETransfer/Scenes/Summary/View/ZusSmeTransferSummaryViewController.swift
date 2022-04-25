import Operative
import UI
import CoreFoundationLib

final class ZusSmeTransferSummaryViewController: OperativeSummaryViewController {
    
    private let presenter: ZusSmeTransferSummaryPresenterProtocol
    
    init(presenter: ZusSmeTransferSummaryPresenterProtocol) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupNavigationBar() {
        let builder = NavigationBarBuilder(style: .sky, title: .title(key: "genericToolbar_title_summary"))
        builder.setRightActions(.close(action: NavigationBarAction.selector(#selector(close))))
        builder.build(on: self, with: nil)
    }
}

private extension ZusSmeTransferSummaryViewController {
    @objc func close() {
        self.presenter.close()
    }
}

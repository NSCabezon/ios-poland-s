import Operative
import UI
import CoreFoundationLib

final class ZusTransferSummaryViewController: OperativeSummaryViewController {
    
    private let presenter: ZusTransferSummaryPresenterProtocol
    
    init(presenter: ZusTransferSummaryPresenterProtocol) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupNavigationBar() {
        let builder = NavigationBarBuilder(style: .sky, title: .title(key: "genericToolbar_title_summary"))
        builder.setRightActions(.close(action: #selector(close)))
        builder.build(on: self, with: nil)
    }
}

private extension ZusTransferSummaryViewController {
    @objc func close() {
        self.presenter.goToZusTransfer()
    }
}

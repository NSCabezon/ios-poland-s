import Foundation
import CoreFoundationLib
import SANPLLibrary
import PLUI

protocol PLQuickBalanceViewProtocol: AnyObject, LoaderPresentable, ErrorPresentable {
    func show(output: GetLastTransactionUseCaseOkOutput)
    func showIntro()
    func showServiceInaccesible()
    func pop()
    func showEnableQuickBalanceView()
}

class PLQuickBalanceViewController: UIViewController {
    private var presenter: PLQuickBalancePresenterProtocol
    private let quickBalanceView = PLQuickBalanceView()
    private let introView = PLQuickBalanceIntroView()
    
    init(presenter: PLQuickBalancePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 242/255.0,
                                            green: 244/255.0,
                                            blue: 246/255.0,
                                            alpha: 1)
        presenter.viewDidLoad()
    }
}

extension PLQuickBalanceViewController: PLQuickBalanceViewProtocol {
    func showServiceInaccesible() {
        DispatchQueue.main.async {
            self.quickBalanceView.showServiceInaccesible()
            self.quickBalanceView.delegate = self
            self.view = self.quickBalanceView
        }
    }
    
    func pop() {
        self.presenter.pop()
    }
    
    func showEnableQuickBalanceView() {
        DispatchQueue.main.async {
            self.presenter.showEnableQuickBalanceView()
        }
    }
    
    func show(output: GetLastTransactionUseCaseOkOutput) {
        DispatchQueue.main.async {
            self.quickBalanceView.fillWith(items: output.dto)
            self.quickBalanceView.delegate = self
            self.view = self.quickBalanceView
        }
    }
    
    func showIntro() {
        DispatchQueue.main.async {
            self.view = self.introView
            self.introView.delegate = self
        }
    }
}

extension PLQuickBalanceViewController: PLQuickBalanceIntroActionsDelegate {
    func enableQuickBalance() {
        showEnableQuickBalanceView()
    }
    
    func closeIntro() {
        pop()
    }
}

extension PLQuickBalanceViewController: PLQuickBalanceViewActionsDelegate {
    func close() {
        pop()
    }
}


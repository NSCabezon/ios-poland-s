import Commons
import CoreFoundationLib
import SANPLLibrary
import PLUI

let BLIK_TOTAL_DURATION: TimeInterval = 120

protocol BLIKHomePresenterProtocol: MenuTextWrapperProtocol {
    var view: BLIKHomeViewProtocol? { get set }
    func viewWillAppear()
    func viewDidLoad()
    
    func didSelectClose()
    func didSelectCopyCode(_ code: String)
    func didSelectMenuItem(_ item: BLIKMenuItem)
    func didSelectGenerate()
}

final class BLIKHomePresenter {
    weak var view: BLIKHomeViewProtocol?
    let dependenciesResolver: DependenciesResolver
    
    private var wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>?
    private let timer = TimerHandler()
    private let contactsPermission: ContactPermissionAuthorizatorProtocol

    private var getWalletsActiveUseCase: GetWalletsActiveProtocol {
        dependenciesResolver.resolve()
    }
    
    private var getTicketUseCase: GetPSPTicketProtocol {
        dependenciesResolver.resolve()
    }
    
    private var getTrnToConfUseCase: GetTrnToConfProtocol {
        dependenciesResolver.resolve()
    }
    
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.contactsPermission = ContactPermissionAuthorizator()
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackgroung), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        startInitialScenario()
    }
    
    @objc private func handleEnterBackgroung() {
        timer.stopTimer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BLIKHomePresenter: BLIKHomePresenterProtocol {
    func viewWillAppear() {
        resumePendingProgressAnimationIfNeeded()
        startInitialScenario()
    }
    
    func viewDidLoad() {
        setMenuItems()
    }
    
    func didSelectClose() {
        coordinator.pop()
    }
    
    func didSelectCopyCode(_ code: String) {
        UIPasteboard.general.string = code
        view?.showSnackbar(message: localized("pl_blik_alert_copySuccess"), type: .success)
    }
    
    func didSelectMenuItem(_ item: BLIKMenuItem) {
        switch item {
        case .cheque:
            tryToShowCheques()
        case .settings:
            tryToShowSettings()
        case .mobileTransfer:
            tryToShowContacts()
        case .aliasPayment:
            coordinator.showAliasPayment()
        }
    }
    
    func didSelectGenerate() {
        timer.stopTimer()
        view?.showLoader()
        regenerateNewCode()
    }
    
    private func tryToShowCheques() {
        guard let wallet = wallet else {
            handleServiceInaccessible()
            return
        }

        coordinator.showCheques(with: wallet)
    }
    
    private func tryToShowSettings() {
        guard let wallet = wallet else {
            handleServiceInaccessible()
            return
        }

        coordinator.showSettings(with: wallet)
    }
    
    private func tryToShowContacts() {
        guard let viewController = view?.associatedDialogView as? BLIKHomeViewController else { return }
        contactsPermission.authorizeContactPermission(in: viewController) {[weak self] in
            self?.coordinator.showContacts()
        }
    }
}

private extension BLIKHomePresenter {
    var coordinator: BLIKHomeCoordinatorProtocol {
        dependenciesResolver.resolve(for: BLIKHomeCoordinatorProtocol.self)
    }
    
    func startCountdown(totalDuration: TimeInterval, remainingDuration: TimeInterval) {
        timer.didUpdate = { [weak self] counter in
            self?.view?.updateCounter(remainingSeconds: counter)
            
            if (TimeInterval(counter) / totalDuration) <= 0.25 {
                self?.view?.enableGenerateNewCode()
            }
        }
        
        timer.didEnd = { [weak self] in
            self?.view?.hideCodeComponent()
        }
        
        view?.startProgressAnimation(totalDuration: totalDuration, remainingDuration: remainingDuration)
        timer.startTimer(duration: remainingDuration)
    }
    
    func setMenuItems() {
        view?.setMenuItems(BLIKMenuItem.allCases.map(BLIKMenuViewModel.init))
    }
    
    func startInitialScenario() {
        view?.showLoader()
        
        Scenario(useCase: getWalletsActiveUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                switch output.serviceStatus {
                case let .available(wallet):
                    self?.wallet = SharedValueBox(value: wallet)
                    self?.getInitialTransactionsToConfirm()
                case .unavailable:

                    self?.view?.hideLoader() {
                        self?.handleServiceInaccessible()
                    }
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader() {
                    self?.handleServiceInaccessible()
                }
            }
    }
    
    func regenerateNewCode() {
        generateNewCode(true)
    }

    func generateNewCode(_ updateCode: Bool = false) {
        Scenario(useCase: getTicketUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                DispatchQueue.main.async {
                    self?.view?.hideLoader() {
                        self?.initializeNewCode(using: output)
                    }
                }
                
                guard !updateCode else { return }
                DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    self?.getTransactionsToConfirm()
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader() {
                    self?.handleServiceInaccessible()
                }
            }
    }
    
    func getInitialTransactionsToConfirm() {

        Scenario(useCase: getTrnToConfUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.view?.hideLoader() {
                    UIDevice.current.vibrate()
                    self?.handleTransactionOutput(output.transaction)
                }
            }
            .onError { [weak self] error in
                guard let useCaseError = GetTrnToConfErrorResult(rawValue: error.getErrorDesc() ?? ""),
                      useCaseError == .watchStatus else {
                    self?.view?.hideLoader() {
                        self?.handleServiceInaccessible()
                    }
                    return
                }

                self?.generateNewCode()
            }
    }

    func getTransactionsToConfirm() {
        Scenario(useCase: getTrnToConfUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.view?.hideLoader() {
                    UIDevice.current.vibrate()
                    self?.handleTransactionOutput(output.transaction)
                }
            }
            .onError {[weak self] error in
                let useCaseError = GetTrnToConfErrorResult(rawValue: error.getErrorDesc() ?? "")
                switch useCaseError {
                case .watchStatus:
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        self?.getTransactionsToConfirm()
                    }
                case .noConnection:
                    self?.view?.hideLoader() {
                        self?.view?.showErrorMessage(localized("pl_generic_alert_textUnstableConnection"), onConfirm: {[weak self] in
                            self?.coordinator.pop()
                        })
                    }
                default:
                    self?.view?.hideLoader() {
                        self?.handleServiceInaccessible()
                    }
                }

            }
    }
    
    func handleTransactionOutput(_ output: GetTrnToConfDTO) {
        let mapper = TransactionMapper()
        do {
            let transaction = try mapper.map(dto: output)
            view?.hideLoader {
                 self.coordinator.showBLIKConfirmation(viewModel: .init(transaction:  transaction))
            }
            
        } catch {
            view?.hideLoader() {[weak self] in
                self?.handleServiceInaccessible()
            }
        }
    }

    func initializeNewCode(using output: GetPSPTicketUseCaseOkOutput) {
        let code = output.code.addingCharacter(" ", atOffset: 3)
        let remainingSeconds = output.secondsRemaining
        view?.setCode(code)
        startCountdown(totalDuration: BLIK_TOTAL_DURATION, remainingDuration: remainingSeconds)
    }
    
    func handleServiceInaccessible() {
        view?.showServiceInaccessibleMessage {[weak self] in
            self?.coordinator.pop()
        }
    }
    
    func resumePendingProgressAnimationIfNeeded() {
        guard timer.counter != 0 else { return }
        timer.stopTimer()
        view?.startProgressAnimation(
            totalDuration: BLIK_TOTAL_DURATION,
            remainingDuration: TimeInterval(timer.counter)
        )
    }
}

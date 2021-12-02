public protocol AccountSelectorPresenterProtocol {
    func viewDidLoad()
    func didSelectAccount(at index: Int)
    func didPressClose()
    func didCloseProcess()
}

extension AccountSelectorPresenterProtocol {
    public func didCloseProcess() { }
}

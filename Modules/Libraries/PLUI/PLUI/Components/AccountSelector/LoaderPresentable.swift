import UI

public protocol LoaderPresentable: LoadingViewPresentationCapable {
    func showLoader()
    func hideLoader(completion: (() -> Void)?)
}

extension LoaderPresentable where Self: UIViewController {
    public func showLoader() {
        showLoading()
    }
    
    public func hideLoader(completion: (() -> Void)?) {
        dismissLoading(completion: completion)
    }
}

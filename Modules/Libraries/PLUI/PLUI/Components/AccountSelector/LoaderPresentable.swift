import UI

public protocol LoaderPresentable {
    func showLoader()
    func hideLoader(completion: (() -> Void)?)
}

extension LoaderPresentable where Self: UIViewController {
    public func showLoader() {
        let vc = navigationController ?? self
        LoadingCreator.showGlobalLoading(
            info: .init(
                type: .onScreen(controller: vc, completion: nil),
                loadingText: .empty,
                placeholders: nil,
                topInset: nil,
                background: .white,
                loadingImageType: .points,
                style: .onView
            )
            , controller: vc
        )
    }
    
    public func hideLoader(completion: (() -> Void)?) {
        LoadingCreator.hideGlobalLoading(completion: completion)
    }
}

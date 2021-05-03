import DomainCommon
import Commons
import Models

protocol PLLoginPresenterProtocol {
    var view: PLLoginViewProtocol? { get set }
    func viewDidLoad()
    //TODO: Add more methos
}

final class PLLoginPresenter {
    
    weak var view: PLLoginViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension PLLoginPresenter: PLLoginPresenterProtocol {
    
    func viewDidLoad() {
        //TODO: Add implementation
    }
}

extension PLLoginPresenter: TrackerScreenProtocol {
    var screenId: String? {
        return "PLLogin" //TODO: Return tracked screen name
    }
    
    var emmaScreenToken: String? {
        return nil
    }
}

extension PLLoginPresenter: ScreenTrackable {
    var trackerManager: TrackerManager {
        return dependenciesResolver.resolve(for: TrackerManager.self)
    }
}

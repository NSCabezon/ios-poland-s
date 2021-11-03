import Foundation

public enum User {
    case demo
    case custom(String, isPb: Bool)
    
    var user: String {
        switch self {
        case .demo: return "12345678Z"
        case .custom(let user, _): return user
        }
    }
    
    var isPB: Bool {
        switch self {
        case .demo:
            return true
        case .custom(_, isPb: let isPb):
            return isPb
        }
    }
}

import Foundation

final class SessionFeIdFactory {

    typealias SessionFeId = String
    static let idLength: Int = 24
    
    static func generateNewSessionFeId() -> SessionFeId {
        return String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(idLength))
    }
    
}

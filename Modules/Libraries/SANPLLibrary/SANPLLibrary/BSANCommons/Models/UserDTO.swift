
public struct UserDTO: Codable {
    public var isPB: Bool
    public let loginType: UserLoginType
    public let login: String
    
    public init(loginType: UserLoginType, login: String) {
        self.login = login
        self.loginType = loginType
        self.isPB = false
    }
}

public enum UserLoginType: String , Codable {
    case U = "User"
    
    public static func findBy(type: String?) -> UserLoginType? {
        if let type = type, !type.isEmpty {
            switch (type.uppercased()) {
            case U.rawValue.uppercased():
                return U
            default:
                return nil
            }
        }
        return nil
    }
    
    public init?(_ type: String) {
        self.init(rawValue: type)
    }
    
    public var type: String {
        get {
            return self.rawValue
        }
    }
    
    public var name: String {
        get {
            return String(describing: self)
        }
    }
}

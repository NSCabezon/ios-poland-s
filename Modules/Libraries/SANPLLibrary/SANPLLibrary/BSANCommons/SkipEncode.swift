
@propertyWrapper
public struct SkipEncode<T: Decodable> {
    
    public var wrappedValue: T?
    
    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
}

extension SkipEncode: Codable {
    public init(from decoder: Decoder) throws {
       wrappedValue = try? decoder.singleValueContainer().decode(T.self)
    }
    public func encode(to encoder: Encoder) throws { }
}

extension KeyedEncodingContainer {
    mutating func encode<T>(_ value: SkipEncode<T>, forKey key: K) throws { }
}

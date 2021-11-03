import Foundation

@propertyWrapper
struct DecodeFile<DataType: Decodable> {
    let name: String
    let type: String = "json"
    let fileManager: FileManager = .default
    let bundle: Bundle = Bundle(for: CancelBLIKTransactionUseCaseTests.self)
    let decoder = JSONDecoder()

    var wrappedValue: DataType {
        guard let path = bundle.path(forResource: name, ofType: type) else { fatalError("Resource not found") }
        guard let data = fileManager.contents(atPath: path) else { fatalError("File not loaded") }
        return try! decoder.decode(DataType.self, from: data)
    }
}

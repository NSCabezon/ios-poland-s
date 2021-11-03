import Foundation

extension String {
    func addingCharacter(_ character: Character, atOffset offset: Int) -> String {
        var string = self
        let index = string.index(string.startIndex, offsetBy: offset)
        string.insert(character, at: index)
        return string
    }
    
    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
        }.joined(separator: separator))
    }
}

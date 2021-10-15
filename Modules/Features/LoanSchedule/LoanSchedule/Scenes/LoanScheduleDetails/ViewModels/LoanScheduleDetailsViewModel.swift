import Foundation

struct LoanScheduleDetailsViewModel {
    var elements: [Element]
}

extension LoanScheduleDetailsViewModel {
    
    struct Element {
        let title: String
        let value: String
        let valueStyle: ValueStyle
        let separatorLine: SeparatorLine
    }
    
    enum ValueStyle {
        case big
        case medium
        case small
    }
    
    enum SeparatorLine {
        case none
        case whole
        case withMargins
    }
}

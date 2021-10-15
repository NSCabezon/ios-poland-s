import SANPLLibrary
import PLCommons

public final class LoanScheduleMockData {
    
    public enum LoanScheduleMockState {
        case normal, empty, error
    }
    
    public var state: LoanScheduleMockState = .normal
    
    public init() {}
    
    @DecodeFile(name: "loanSchedule", bundle: Bundle.module!)
    private var loanSchedule: LoanScheduleDTO?
    
    private var loanScheduleEmpty: LoanScheduleDTO? {
        let data = Data("{}".utf8)
        return try? JSONDecoder().decode(LoanScheduleDTO.self, from: data)
    }
    
    public var loanScheduleDTO: LoanScheduleDTO? {
        switch state {
        case .normal:
            return loanSchedule
        case .empty:
            return loanScheduleEmpty
        case .error:
            return nil
        }
    }
    
}

import SANPLLibrary
import PLCommons

public final class PLHelpCenterMockData {
    
    public var forceOnlineAdvisorError: Bool = false
    public var forceHelpQuestionsError: Bool = false
    public var forceOnlineAdvisorUserContextError: Bool = false
    
    public init() {}
    
    @DecodeFile(name: "onlineAdvisor", bundle: Bundle.module!)
    private var onlineAdvisor: OnlineAdvisorDTO?
    public var onlineAdvisorDTO: OnlineAdvisorDTO? {
        forceOnlineAdvisorError ? nil : onlineAdvisor
    }
    
    @DecodeFile(name: "helpQuestions", bundle: Bundle.module!)
    private var helpQuestions: HelpQuestionsDTO?
    public var helpQuestionsDTO: HelpQuestionsDTO? {
        forceHelpQuestionsError ? nil : helpQuestions
    }
    
    @DecodeFile(name: "onlineAdvisorUserContext", bundle: Bundle.module!)
    private var onlineAdvisorUserContext: OnlineAdvisorUserContextDTO?
    public var onlineAdvisorUserContextDTO: OnlineAdvisorUserContextDTO? {
        forceOnlineAdvisorUserContextError ? nil : onlineAdvisorUserContext
    }
}

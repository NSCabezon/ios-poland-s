import Transfer

struct PLOneTransferHomeVisibilityModifier: OneTransferHomeVisibilityModifier {
    public var shouldShowFavoritesCarousel: Bool {
        return false
    }
    
    public var shouldShowNewFavoriteOption: Bool {
        return false
    }
    
    public var shouldShowRecentAndScheduledCarousel: Bool {
        return false
    }
    
    public var newTransferType: OneAdditionalFavoritesActionsViewModel.ViewType {
        return .newTransferSimple
    }
}

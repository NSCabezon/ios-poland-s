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
        return .custom(circleImageKey: "oneIcnPlus",
                       titleKey: "transfer_title_sendOptions",
                       descriptionKey: "transfer_text_button_newSend",
                       extraImageKey: nil)
    }
}

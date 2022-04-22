//
//  ItemSelectorConfiguration.swift
//  PLScenes
//
//  Created by 185167 on 10/02/2022.
//

public struct ItemSelectorConfiguration<Item: SelectableItem> {
    public let navigationTitle: String
    public let searchMode: SearchMode
    public let sections: [ItemSelectorSection]
    public let selectedItem: Item?
    public let shouldPopControllerAfterSelection: Bool
    public let shouldShowDialogBeforeClose: Bool

    public init(
        navigationTitle: String,
        searchMode: SearchMode,
        sections: [ItemSelectorSection],
        selectedItem: Item?,
        shouldPopControllerAfterSelection: Bool = true,
        shouldShowDialogBeforeClose: Bool
    ) {
        self.navigationTitle = navigationTitle
        self.searchMode = searchMode
        self.sections = sections
        self.selectedItem = selectedItem
        self.shouldPopControllerAfterSelection = shouldPopControllerAfterSelection
        self.shouldShowDialogBeforeClose = shouldShowDialogBeforeClose
    }
    
    public struct ItemSelectorSection {
        public let sectionTitle: String
        public let items: [Item]
        
        public init(
            sectionTitle: String,
            items: [Item]
        ) {
            self.sectionTitle = sectionTitle
            self.items = items
        }
    }
    
    public enum SearchMode {
        case enabled(SearchConfiguration)
        case disabled
        
        public struct SearchConfiguration {
            public let searchBarPlaceholderText: String
            public let emptySearchResultMessage: String
            
            public init(
                searchBarPlaceholderText: String,
                emptySearchResultMessage: String
            ) {
                self.searchBarPlaceholderText = searchBarPlaceholderText
                self.emptySearchResultMessage = emptySearchResultMessage
            }
        }
    }
}

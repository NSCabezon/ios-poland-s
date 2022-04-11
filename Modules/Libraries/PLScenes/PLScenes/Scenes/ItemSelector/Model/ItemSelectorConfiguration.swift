//
//  ItemSelectorConfiguration.swift
//  PLScenes
//
//  Created by 185167 on 10/02/2022.
//

public struct ItemSelectorConfiguration<Item: SelectableItem> {
    public let navigationTitle: String
    public let isSearchEnabled: Bool
    public let sections: [ItemSelectorSection]
    public let selectedItem: Item?
    public let shouldPopControllerAfterSelection: Bool

    public init(
        navigationTitle: String,
        isSearchEnabled: Bool,
        sections: [ItemSelectorSection],
        selectedItem: Item?,
        shouldPopControllerAfterSelection: Bool = true
    ) {
        self.navigationTitle = navigationTitle
        self.isSearchEnabled = isSearchEnabled
        self.sections = sections
        self.selectedItem = selectedItem
        self.shouldPopControllerAfterSelection = shouldPopControllerAfterSelection
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
}

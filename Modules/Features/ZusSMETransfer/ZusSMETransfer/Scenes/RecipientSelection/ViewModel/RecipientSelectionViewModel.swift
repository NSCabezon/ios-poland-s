struct RecipientSelectionViewModel {
    let cellViewModelTypes: [RecipientCellViewModelType]
    let isRecipientListEmpty: Bool
}

enum RecipientCellViewModelType {
    case recipient(RecipientCellViewModel)
    case empty(EmptyCellViewModel)
}

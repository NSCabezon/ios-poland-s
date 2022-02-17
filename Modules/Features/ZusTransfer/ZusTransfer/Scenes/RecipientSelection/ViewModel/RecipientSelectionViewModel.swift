struct RecipientSelectionViewModel {
    let cellsViewModel: [RecipientCellViewModelType]
    let isRecipientListEmpty: Bool
}

enum RecipientCellViewModelType {
    case recipient(RecipientCellViewModel)
    case empty(EmptyCellViewModel)
}

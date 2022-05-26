
import UIKit

class PLQuickBalanceSetAccountCell: UITableViewCell {
    let selectorView = PLQuickBalanceSelectableView()
    weak var delegate: PLQuickBalanceSetAccountDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureView() {
        self.selectionStyle = .none
        selectorView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(selectorView)
        NSLayoutConstraint.activate([
            selectorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            selectorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            selectorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            selectorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    func fill(title: String, description: String, index: Int, isSelected: Bool) {
        let status: PLQuickBalanceSelectableViewModel.Status = isSelected ? .activated : .inactive
        let vm = PLQuickBalanceSelectableViewModel(leftTextKey: title, rightTextKey: description, status: status)
        selectorView.setViewModel(vm, index: index)
        selectorView.delegate = self
    }
}

extension PLQuickBalanceSetAccountCell: PLQuickBalanceSelectableDelegate {
    func didSelectOneSmallSelectorListView(_ index: Int) {
        delegate?.didSelect(index)
    }
}

import UIKit

final class TransactionTableViewCell: UITableViewCell {
    private let referenceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let mainHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = ViewConstants.mediumMargin
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
    }
    
    private func setupHierarchy() {
        mainHorizontalStackView.addArrangedSubview(referenceLabel)
        mainHorizontalStackView.addArrangedSubview(amountLabel)
        addSubview(mainHorizontalStackView)
    }
    
    private func setupLayout() {
        mainHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHorizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: ViewConstants.mediumMargin),
            mainHorizontalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: ViewConstants.mediumMargin),
            mainHorizontalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -ViewConstants.mediumMargin),
            mainHorizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ViewConstants.mediumMargin)
        ])
    }
    
    func update(with viewModel: TransactionViewModel) {
        amountLabel.textColor = viewModel.transactionColor
        amountLabel.text = viewModel.transactionAmountDisplayText
        referenceLabel.text = viewModel.counterPartyNameDisplayText
    }
    
    override func prepareForReuse() {
        referenceLabel.text = nil
        amountLabel.text = nil
    }
}

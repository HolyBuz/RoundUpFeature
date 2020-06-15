import UIKit

protocol RoundUpViewDelegate: class {
    func didPressRoundUpButton(_ roundUpViewModel: RoundUpViewModel)
}

final class RoundUpView: UIView {
    private let roundUpAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var roundUpButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressRoundUpButton), for: .touchUpInside)
        button.setTitle(NSLocalizedString("Transfer Money", comment: ""), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        return button
    }()
    
    weak var delegate: RoundUpViewDelegate?
    
    var roundUpViewModel: RoundUpViewModel? {
        didSet {
            roundUpAmountLabel.text = roundUpViewModel?.lastWeekRoundUpsDisplayText
            roundUpButton.isEnabled = roundUpViewModel?.amount.minorUnits.isZero == false
            roundUpButton.backgroundColor = roundUpButton.isEnabled ? .white : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBlue
    }

    private func setupHierarchy() {
        addSubview(roundUpAmountLabel)
        addSubview(roundUpButton)
    }
    
    private func setupLayout() {
        roundUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundUpButton.widthAnchor.constraint(equalToConstant: 150),
            roundUpButton.heightAnchor.constraint(equalToConstant: 50),
            roundUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            roundUpButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -ViewConstants.mediumMargin)
        ])
        
        roundUpAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundUpAmountLabel.topAnchor.constraint(equalTo: topAnchor, constant: ViewConstants.mediumMargin),
            roundUpAmountLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: ViewConstants.mediumMargin),
            roundUpAmountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -ViewConstants.mediumMargin),
            roundUpAmountLabel.bottomAnchor.constraint(equalTo: roundUpButton.topAnchor, constant: -ViewConstants.mediumMargin)
        ])
    }
    
    @objc private func didPressRoundUpButton() {
        guard let viewModel = roundUpViewModel else { return }
        
        delegate?.didPressRoundUpButton(viewModel)
    }
    
    func update(with viewModel: RoundUpViewModel) {
        roundUpViewModel = viewModel
    }
}

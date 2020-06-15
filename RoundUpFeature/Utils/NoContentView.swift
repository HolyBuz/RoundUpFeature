import UIKit

protocol NoContentViewDelegate: class {
    func didTapRetryButton()
}

final class NoContentView: UIView {
    
    private let mainVerticalStackView = UIStackView()
    private let imageView = UIImageView(image: UIImage(named: "alert"))

    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Sorry, no data from this country at the moment!", comment: "")
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 20
        return button
    }()
    
    weak var delegate: NoContentViewDelegate?
    
    init(shouldHideImage: Bool = false) {
        super.init(frame: .zero)
        
        setupViews()
        setupHierarchy()
        setupLayout()
        
        imageView.isHidden = shouldHideImage
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        isHidden = true
        
        mainVerticalStackView.axis = .vertical
        mainVerticalStackView.spacing = 20
    }
    
    private func setupHierarchy() {
        mainVerticalStackView.addArrangedSubview(imageView)
        mainVerticalStackView.addArrangedSubview(textLabel)

        addSubview(mainVerticalStackView)
        addSubview(retryButton)
    }
    
    private func setupLayout() {
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            retryButton.widthAnchor.constraint(equalToConstant: 70),
            retryButton.heightAnchor.constraint(equalToConstant: 50),
            retryButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -ViewConstants.mediumMargin),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        mainVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainVerticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: ViewConstants.mediumMargin),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: -ViewConstants.mediumMargin),
            mainVerticalStackView.leftAnchor.constraint(equalTo: leftAnchor),
            mainVerticalStackView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    @objc private func didTapRetryButton() {
        isHidden = true
        delegate?.didTapRetryButton()
    }
    
    func update(with error: Error) {
        isHidden = false
        textLabel.text = error.localizedDescription
    }
}

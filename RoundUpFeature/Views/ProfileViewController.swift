import UIKit

final class ProfileViewController: UIViewController {
    private let noContentView = NoContentView()
    private let roundUpView = RoundUpView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.registerCell(ofType: TransactionTableViewCell.self)
        return tableView
    }()
    
    private var transactionViewModels = [TransactionViewModel]()
    
    /*
        Debug boolean to simulate that transactions are rounded and transfered already,
        since this is normally handled by the API at every transaction.
        It's set to true the first time RoundUpView's button Transfer is pressed.
        Otherwise everytime ProfileFacade's method createSavingsGoal is called the roundUpView
        will calculate new roundUps.
     */
    private var hasAlreadyRoundedUp = false
    
    private var coordinator: MainCoordinator
    private let facade: ProfileFacade
    
    init(facade: ProfileFacade, coordinator: MainCoordinator) {
        self.facade = facade
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        roundUpView.delegate = self
        noContentView.delegate = self
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(roundUpView)
        view.addSubview(noContentView)
    }
    
    private func setupLayout() {
        roundUpView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundUpView.heightAnchor.constraint(equalToConstant: 150),
            roundUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            roundUpView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            roundUpView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: roundUpView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        noContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noContentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noContentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            noContentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    override func viewDidLoad() {
        refreshTransactions()
    }
    
    private func refreshTransactions() {
        facade.getTransactions(completion: { [weak self] result in
            switch result {
            case .success(let profileViewModel):
                self?.update(with: profileViewModel)
            case .failure(let error):
                self?.update(with: error)
            }
        })
    }
    
    private func update(with viewModel: ProfileViewModel) {
        if !hasAlreadyRoundedUp {
            roundUpView.update(with: viewModel.roundUpViewModel)
        }
        transactionViewModels = viewModel.transactionViewModels
        tableView.reloadData()
    }
    
    private func update(with error: Error) {
        noContentView.update(with: error)
    }
}

//MARK:- UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionTableViewCell = tableView.dequeueCell(ofType: TransactionTableViewCell.self)
        cell.update(with: transactionViewModels[indexPath.row])
        return cell
    }
}

//MARK:- NoContentViewDelegate
extension ProfileViewController: NoContentViewDelegate {
    func didTapRetryButton() {
        refreshTransactions()
    }
}

//MARK:- RoundUpViewDelegate
extension ProfileViewController: RoundUpViewDelegate {
    func didPressRoundUpButton(_ roundUpViewModel: RoundUpViewModel) {
        hasAlreadyRoundedUp = true
        facade.createSavingsGoal(roundUpViewModel: roundUpViewModel, completion: { [weak self] result in
            switch result {
            case .success(let roundUpViewModel):
                self?.roundUpView.update(with: roundUpViewModel)
                self?.refreshTransactions()
                
            case .failure(let error):
                self?.update(with: error)
            }
        })
    }
}


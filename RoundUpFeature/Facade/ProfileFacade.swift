import Foundation

protocol ProfileFacade {
    func getTransactions(completion: @escaping (Result<ProfileViewModel, Error>) -> ())
    func createSavingsGoal(roundUpViewModel: RoundUpViewModel, completion: @escaping (Result<RoundUpViewModel, Error>) -> ())
}

final class ProfileFacadeImpl: ProfileFacade {
    private let accountsService: AccountsService
    private let transactionsService: TransactionsService
    private let savingsGoalsService: SavingsGoalsService
    
    private var accountUid: AccountUID?
    private var categoryUid: CateogoryUID?
    private var savingsGoalUid: SavingsGoalUID?
    
    private let dispatchGroup = DispatchGroup()
    private let dispatchQueue = DispatchQueue.global()
    
    init(service: Service) {
        accountsService = service.accountsService
        transactionsService = service.transactionsService
        savingsGoalsService = service.savingsGoalsService
    }
    
    func getTransactions(completion: @escaping (Result<ProfileViewModel, Error>) -> ()) {
        
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {  [weak self] in
            guard let self = self else { return }
            
            self.accountsService.getAccounts(completion: { result in
                switch result {
                case .success(let accounts):
                    
                    //I'm assuming the account and categogry needed are always the first one for this demo
                    self.accountUid = accounts.map { $0.accountUid }.first
                    self.categoryUid = accounts.map { $0.defaultCategory }.first
                    
                case .failure(let error):
                    completion(.failure(error))
                }
                
                self.dispatchGroup.leave()
            })
            
            self.dispatchGroup.notify(queue: self.dispatchQueue) {
                guard let accountUid = self.accountUid, let categoryUid = self.categoryUid, let changesSince = Date.oneWeekAgo()?.toString() else { return }
                
                self.dispatchQueue.async {
                    self.transactionsService.getTransactions(accountUid: accountUid, categoryUid: categoryUid, changesSince: changesSince, completion: { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let transactions):
                                completion(.success(ProfileViewModel(transactions: transactions)))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    })
                }
            }
        }
    }
    
    func createSavingsGoal(roundUpViewModel: RoundUpViewModel, completion: @escaping (Result<RoundUpViewModel, Error>) -> ()) {
        guard let accountUID = accountUid else { return }
        
        //Simulating a fetched savingsGoal or a newly created one, instead of getting all savingsGoals and check if any is already there and creating a new one in case
        let placeholderSavingGoal = SavingsGoal(name: "Test Savings Goal",
                                                currency: .GBP,
                                                target: Amount(currency: .GBP, minorUnits: 1000),
                                                base64EncodedPhoto: "base64EncodedPhoto")
        
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {  [weak self] in
            guard let self = self else { return }
            
            self.savingsGoalsService.createSavingsGoal(savingsGoal: placeholderSavingGoal, accountUid: accountUID, completion: { result in
                switch result {
                case .success(let savingsGoaldUID):
                    self.savingsGoalUid = savingsGoaldUID
                case .failure(let error):
                    completion(.failure(error))
                }
                
                self.dispatchGroup.leave()
            })
            
            self.dispatchGroup.notify(queue: self.dispatchQueue) {
                guard let savingsGoaldUID = self.savingsGoalUid else { return }
                
                self.dispatchQueue.async {
                    self.savingsGoalsService.addMoneyIntoSavingsGoal(accountUid: accountUID, savingsGoalUid: savingsGoaldUID, amount: roundUpViewModel.amount, completion: { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                let roundUpViewModel = RoundUpViewModel(amount: Amount(currency: .GBP,
                                                                                       minorUnits: 0))
                                completion(.success(roundUpViewModel))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    })
                }
            }
        }
    }
}

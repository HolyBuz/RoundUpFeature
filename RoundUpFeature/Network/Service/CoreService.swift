protocol Service: class {
    var accountsService: AccountsService { get set }
    var transactionsService: TransactionsService { get set }
    var savingsGoalsService: SavingsGoalsService { get set }
}

final class CoreService: Service {
    var accountsService: AccountsService
    var transactionsService: TransactionsService
    var savingsGoalsService: SavingsGoalsService
    private let backend = Backend()
    
    init() {
        self.accountsService = AccountsServiceImpl(backend: backend)
        self.transactionsService = TransactionsServiceImpl(backend: backend)
        self.savingsGoalsService = SavingsGoalsServiceImpl(backend: backend)
    }
}

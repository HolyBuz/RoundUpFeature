import XCTest
@testable import RoundUpFeature

final class CoreServiceMock: Service {
    var accountsService: AccountsService
    var transactionsService: TransactionsService
    var savingsGoalsService: SavingsGoalsService
    
    init() {
        accountsService = AccountsServiceMock()
        transactionsService = TransactionsServiceMock()
        savingsGoalsService = SavingsGoalsServiceMock()
    }
}

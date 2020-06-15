import XCTest
@testable import RoundUpFeature

class TransactionViewModelTests: XCTestCase {
    
    var transactionViewModel: TransactionViewModel!

    override func setUp() {
        super.setUp()
        transactionViewModel = TransactionViewModel(transaction: Transaction.testData())
    }
    
    func testTransactionViewModel_correctCounterpartyText() {
        XCTAssertEqual(transactionViewModel.counterPartyNameDisplayText, Transaction.testData().counterPartyName)
    }
    
    func testTransactionViewModel_correctTransactionAmount() {
        XCTAssertEqual(transactionViewModel.transactionAmountDisplayText, "10.0 GBP")
    }
    
    func testTransactionViewModel_correctTextColor_transactionIn() {
        let transactionViewModel = TransactionViewModel(transaction: Transaction.testData(direction: .IN))
        XCTAssertTrue(transactionViewModel.transactionColor == .green)
    }
    
    func testTransactionViewModel_correctTextColor_transactionOut() {
        let transactionViewModel = TransactionViewModel(transaction: Transaction.testData(direction: .OUT))
        XCTAssertTrue(transactionViewModel.transactionColor == .red)
    }
}

import XCTest
@testable import RoundUpFeature

class TransactionsServiceServiceTests: XCTestCase {
    
    var transactionsService: TransactionsServiceMock!
    
    override func setUp() {
        super.setUp()
        
        transactionsService = TransactionsServiceMock()
    }
    
    override func tearDown() {
        transactionsService.getTransactionsResponse = nil
    }
    
    func testGetTransactions() {
        let transactionList: TransactionList = .fromJSON(bundle: Bundle(for: type(of: self)), filename: "TransactionsResponse")!
        transactionsService.getTransactionsResponse = Result.success(transactionList)
        
        let exp = expectation(description: "Get Transactions")
        
        transactionsService.getTransactions(accountUid: UUID().uuidString, categoryUid: UUID().uuidString, changesSince: (Date.oneWeekAgo()?.toString())!, completion: { response in
            switch response {
            case .success(let transactions):
                XCTAssertEqual(transactionList.feedItems.count, transactions.count)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testGetTransactionsFailure() {
        transactionsService.getTransactionsResponse = Result.failure(NSError(domain: "Error", code: 400, userInfo: nil))
        
        let exp = expectation(description: "Get Transactions")
        
        transactionsService.getTransactions(accountUid: UUID().uuidString, categoryUid: UUID().uuidString, changesSince: (Date.oneWeekAgo()?.toString())!, completion: { response in
            switch response {
            case .success:
                XCTFail("This should fail")
            case .failure:
                exp.fulfill()
            }
        })
        
        waitForExpectations(timeout: 0.1)
    }
}


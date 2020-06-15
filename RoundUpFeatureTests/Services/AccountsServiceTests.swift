import XCTest
@testable import RoundUpFeature

class AccountsServiceServiceTests: XCTestCase {
    
    var accountsService: AccountsServiceMock!
    
    override func setUp() {
        super.setUp()
        
        accountsService = AccountsServiceMock()
    }
    
    override func tearDown() {
        accountsService.getAccountsResponse = nil
    }
    
    func testGetAccounts() {
        let accountList: AccountList = .fromJSON(bundle: Bundle(for: type(of: self)), filename: "AccountsResponse")!
        accountsService.getAccountsResponse = Result.success(accountList)
        
        let exp = expectation(description: "Get Accounts")
        
        accountsService.getAccounts(completion: { response in
            switch response {
            case .success(let accounts):
                XCTAssertEqual(accountList.accounts.count, accounts.count)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testGetAccountsFailure() {
        accountsService.getAccountsResponse = Result.failure(NSError(domain: "Error", code: 400, userInfo: nil))
        
        let exp = expectation(description: "Get Accounts")
        
        accountsService.getAccounts(completion: { response in
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


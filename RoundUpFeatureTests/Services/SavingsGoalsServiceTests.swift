import XCTest
@testable import RoundUpFeature

class SavingsGoalsServiceServiceTests: XCTestCase {
    
    var savingsGoalsService: SavingsGoalsServiceMock!
    
    override func setUp() {
        super.setUp()
        
        savingsGoalsService = SavingsGoalsServiceMock()
    }
    
    override func tearDown() {
        savingsGoalsService.createSavingsGoalResponse = nil
    }
    
    func testCreateSavingsGoal() {
        let savingsGoalsResponse: SavingsGoalResponse = .fromJSON(bundle: Bundle(for: type(of: self)), filename: "SavingsGoalResponse")!
        savingsGoalsService.createSavingsGoalResponse = Result.success(savingsGoalsResponse)
        
        let exp = expectation(description: "Create SavingsGoal")
        let savingsGoal = SavingsGoal(name: "Test",
                                      currency: .GBP,
                                      target: Amount(currency: .GBP, minorUnits: 1000),
                                      base64EncodedPhoto: " ")
        
        savingsGoalsService.createSavingsGoal(savingsGoal: savingsGoal, accountUid: UUID().uuidString, completion: { response in
            switch response {
            case .success(let savingsGoal):
                XCTAssertEqual(savingsGoal, savingsGoalsResponse.savingsGoalUid)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
            
        })
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testCreateSavingsGoalFailure() {
        savingsGoalsService.createSavingsGoalResponse = Result.failure(NSError(domain: "Error", code: 400, userInfo: nil))
        
        let exp = expectation(description: "Create SavingsGoal")
        let savingsGoal = SavingsGoal(name: "Test",
                                      currency: .GBP,
                                      target: Amount(currency: .GBP, minorUnits: 1000),
                                      base64EncodedPhoto: " ")
        
        savingsGoalsService.createSavingsGoal(savingsGoal: savingsGoal, accountUid: UUID().uuidString, completion: { response in
            switch response {
            case .success:
                XCTFail("Products fetched")
            case .failure:
                exp.fulfill()
            }
        })

        waitForExpectations(timeout: 0.1)
    }
    
    func testAddMoneyIntoSavingsGoal() {
        let exp = expectation(description: "Add Money Into Savings Goal")
        let amount = Amount(currency: .GBP, minorUnits: 1000)
        
        savingsGoalsService.addMoneyIntoSavingsGoal(accountUid: UUID().uuidString, savingsGoalUid: UUID().uuidString, amount: amount, completion: { response in
            switch response {
            case .success(let success):
                XCTAssertTrue(success)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
            
        })
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testAddMoneyIntoSavingsGoalFailure() {
        let exp = expectation(description: "Add Money Into Savings Goal")
        let amount = Amount(currency: .GBP, minorUnits: 1000)
        savingsGoalsService.addMoneyIntoSavingsGoalShouldFail = true
        
        savingsGoalsService.addMoneyIntoSavingsGoal(accountUid: UUID().uuidString, savingsGoalUid: UUID().uuidString, amount: amount, completion: { response in
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


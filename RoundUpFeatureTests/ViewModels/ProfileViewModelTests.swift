import XCTest
@testable import RoundUpFeature

class ProfileViewModelTests: XCTestCase {
    
    var profileViewModel: ProfileViewModel!

    override func setUp() {
        super.setUp()
        profileViewModel = ProfileViewModel(transactions: [Transaction.testData()])
    }
    
    func testProfileViewModel_createsTransactionViewModels() {
        XCTAssertEqual(profileViewModel.transactionViewModels.count, [Transaction.testData()].count)
    }
}

import XCTest
@testable import RoundUpFeature

class RoundUpViewModelTests: XCTestCase {
    
    var roundUpViewModel: RoundUpViewModel!

    override func setUp() {
        super.setUp()
        roundUpViewModel = RoundUpViewModel(amount: Amount.testData(minorUnits: 10))
    }
    
    func testRoundUpViewModel_lastWeekRoundUpsTextCorrectValue(){
        XCTAssertEqual(roundUpViewModel.lastWeekRoundUpsDisplayText,"Amount Rounded Up: 10.00 GBP")
    }
}

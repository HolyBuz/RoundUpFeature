@testable import RoundUpFeature

extension Transaction {
    static func testData(direction: TransactionDirection = .IN) -> Transaction {
        return Transaction(counterPartyName: "Test Counterparty Name",
                           sourceAmount: Amount.testData(),
                           direction: direction)
    }
}

extension Amount {
    static func testData(minorUnits: Float = 1000) -> Amount{
        return Amount(currency: .GBP, minorUnits: minorUnits)
    }
}


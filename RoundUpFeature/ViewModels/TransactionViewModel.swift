import UIKit

final class TransactionViewModel {
    let transactionColor: UIColor
    let transactionAmountDisplayText: String
    let counterPartyNameDisplayText: String
    
    init(transaction: Transaction) {
        counterPartyNameDisplayText = transaction.counterPartyName
        transactionColor = transaction.direction == .IN ? .green : .red
        transactionAmountDisplayText = (transaction.sourceAmount.minorUnits/100).description + " " + transaction.sourceAmount.currency.rawValue
    }
}

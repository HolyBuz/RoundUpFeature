final class ProfileViewModel {
    let transactionViewModels: [TransactionViewModel]
    let roundUpViewModel: RoundUpViewModel
    
    init(transactions: [Transaction]) {
        transactionViewModels = transactions.map(TransactionViewModel.init)

        let lastWeekRoundUps = transactions
            .filter { $0.direction == .OUT }
            .map {($0.sourceAmount.minorUnits/100).rounded(.up) - ($0.sourceAmount.minorUnits/100)}
            .reduce(0, +)
        
        roundUpViewModel = RoundUpViewModel(amount: Amount(currency: .GBP, minorUnits: lastWeekRoundUps))
    }
}

final class RoundUpViewModel {
    let amount: Amount
    var lastWeekRoundUpsDisplayText: String {
        return "Amount Rounded Up: " + String(format: "%.2f", amount.minorUnits) + " " + amount.currency.rawValue
    }
    
    init(amount: Amount) {
        self.amount = amount
    }
}

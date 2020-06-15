struct SavingsGoal: Codable {
    let name: String
    let currency: Currency
    let target: Amount
    let base64EncodedPhoto : String
}


typealias SavingsGoalUID = String

struct SavingsGoalResponse: Decodable {
    let savingsGoalUid: SavingsGoalUID
}

struct TransferResponse: Decodable {
    let success: Bool
}

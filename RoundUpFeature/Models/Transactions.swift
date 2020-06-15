struct TransactionList: Decodable {
    let feedItems: [Transaction]
}

struct Transaction: Decodable {
    let counterPartyName: String
    let sourceAmount: Amount
    let direction: TransactionDirection
}

struct Amount: Codable {
    let currency: Currency
    let minorUnits: Float
}

enum TransactionDirection: String, Decodable {
    case IN
    case OUT
}

enum Currency: String, Codable {
    case GBP
}

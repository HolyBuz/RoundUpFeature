typealias AccountUID = String
typealias CateogoryUID = String

struct AccountList: Decodable {
    let accounts: [Account]
}

struct Account: Decodable {
    let accountUid: AccountUID
    let defaultCategory: CateogoryUID
    let currency: Currency
}

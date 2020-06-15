import Foundation

protocol TransactionsService: class {
    func getTransactions(accountUid: String, categoryUid: String, changesSince: String, completion :@escaping (Result<[Transaction], Error>) -> ())
}

final class TransactionsServiceImpl: TransactionsService {
    private let backend: Backend
    
    init(backend: Backend) {
        self.backend = backend
    }
    
    func getTransactions(accountUid: String, categoryUid: String, changesSince: String, completion :@escaping (Result<[Transaction], Error>) -> ()) {
        let parameters = ["changesSince": changesSince]
        let resource = Resource(path: "feed/account/\(accountUid)/category/\(categoryUid)", parameters: parameters)
        
        backend.request(resource, type: TransactionList.self, completion: { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let transactionList):
                    let transactions = transactionList.feedItems
                    completion(.success(transactions))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
}

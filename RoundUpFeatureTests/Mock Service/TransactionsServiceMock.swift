import XCTest
@testable import RoundUpFeature

final class TransactionsServiceMock: TransactionsService {
    var getTransactionsResponse: Result<TransactionList, Error>!
    
    func getTransactions(accountUid: String, categoryUid: String, changesSince: String, completion: @escaping (Result<[Transaction], Error>) -> ()) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            switch self.getTransactionsResponse {
            case .success(let trasactionList):
                completion(.success(trasactionList.feedItems))
            case .failure(let error):
                completion(.failure(error))
            case .none: ()
            }
        }
    }
}

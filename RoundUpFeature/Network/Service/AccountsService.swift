import Foundation

protocol AccountsService: class {
    func getAccounts(completion :@escaping (Result<[Account], Error>) -> ())
}

final class AccountsServiceImpl: AccountsService {
    private let backend: Backend
    
    init(backend: Backend) {
        self.backend = backend
    }
    
    func getAccounts(completion :@escaping (Result<[Account], Error>) -> ()) {
        let resource = Resource(path: "accounts")
        
        backend.request(resource, type: AccountList.self, completion: { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let accountList):
                    let transactions = accountList.accounts
                    completion(.success(transactions))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
}


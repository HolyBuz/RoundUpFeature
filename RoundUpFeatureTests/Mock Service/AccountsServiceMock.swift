import XCTest
@testable import RoundUpFeature

final class AccountsServiceMock: AccountsService {
    var getAccountsResponse: Result<AccountList, Error>!
    
    func getAccounts(completion: @escaping (Result<[Account], Error>) -> ()) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            switch self.getAccountsResponse {
            case .success(let accountList):
                completion(.success(accountList.accounts))
            case .failure(let error):
                completion(.failure(error))
            case .none: ()
            }
        }
    }
}

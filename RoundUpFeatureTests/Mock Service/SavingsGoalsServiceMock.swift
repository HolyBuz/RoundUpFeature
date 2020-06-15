import XCTest
@testable import RoundUpFeature

final class SavingsGoalsServiceMock: SavingsGoalsService {
    var createSavingsGoalResponse: Result<SavingsGoalResponse, Error>!
    var addMoneyIntoSavingsGoalShouldFail = false
    
    func createSavingsGoal(savingsGoal: SavingsGoal, accountUid: String, completion: @escaping (Result<SavingsGoalUID, Error>) -> ()) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            switch self.createSavingsGoalResponse {
            case .success(let savingsGoalResponse):
                completion(.success(savingsGoalResponse.savingsGoalUid))
            case .failure(let error):
                completion(.failure(error))
            case .none: ()
            }
        }
    }
    
    func addMoneyIntoSavingsGoal(accountUid: AccountUID, savingsGoalUid: SavingsGoalUID, amount: Amount, completion: @escaping (Result<Bool, Error>) -> ()) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if !self.addMoneyIntoSavingsGoalShouldFail {
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "Error", code: 400, userInfo: nil)))
            }
        }
    }
}


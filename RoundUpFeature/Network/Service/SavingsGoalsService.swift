import Foundation

protocol SavingsGoalsService: class {
    func createSavingsGoal(savingsGoal: SavingsGoal, accountUid: String, completion :@escaping (Result<SavingsGoalUID, Error>) -> ())
    func addMoneyIntoSavingsGoal(accountUid: AccountUID, savingsGoalUid: SavingsGoalUID, amount: Amount, completion :@escaping (Result<Bool, Error>) -> ())
}

final class SavingsGoalsServiceImpl: SavingsGoalsService {
    private let backend: Backend
    
    init(backend: Backend) {
        self.backend = backend
    }

    func createSavingsGoal(savingsGoal: SavingsGoal, accountUid: AccountUID, completion :@escaping (Result<SavingsGoalUID, Error>) -> ()) {
        do {
            let jsonData = try JSONEncoder().encode(savingsGoal)
            let resource = Resource(httpMethod: .PUT, path: "account/\(accountUid)/savings-goals", data: jsonData)
            
            backend.request(resource, type: SavingsGoalResponse.self, completion: { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let savingsGoalResponse):
                        completion(.success(savingsGoalResponse.savingsGoalUid))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            })
        } catch {
            completion(.failure(error))
        }
    }
    
    func addMoneyIntoSavingsGoal(accountUid: AccountUID, savingsGoalUid: SavingsGoalUID, amount: Amount, completion :@escaping (Result<Bool, Error>) -> ()) {
        do {
            let amountDict = ["amount": ["currency": "\(amount.currency)",
                                         "minorUnits": "\(Int64(amount.minorUnits*100))"]]
            let jsonData = try JSONEncoder().encode(amountDict)
            
            let resource = Resource(httpMethod: .PUT, path: "account/\(accountUid)/savings-goals/\(savingsGoalUid)/add-money/\(UUID().uuidString)", data: jsonData)
            
            backend.request(resource, type: TransferResponse.self, completion: { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success:
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            })
        } catch {
            completion(.failure(error))
        }
    }
}


import Foundation

struct Backend {
    private let accessToken = "Bearer eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAH1USY7bMBD8ykDn6YF2Wbrllg_kAS2yaROmSIGknAyC_D2UqMVyBrm5qnqp7qb8O5HOJV2CowROg_lwHq2S-tqjvn8wMyTviZv6EFH0pWhzakGk1QVKThfAphcg6pS3XNTUt2kIpl9j0mVVm-dFm2X1eyLRRyKr8mYmkDEzaf_dKE72h-ShdhuqIWc1CNH3UDImoMUGocImK5C1rGxEqO3NnXTMoIbVeZoR8L5toGx4C5dChLSiF0WZZg1WPGSEsb4xRs7FrEtaVUVNTRg1RSjTkqCt8wxqUbIizXlKWT4PzMxI81KiU7gtVkHjQJ0l5G8vgv8cXwTJSXspJNkzr6TzJ2YFnNtgsiMu_Q6i4j2y20B75IF_WunpDSd_M1a6cDKQmsuH5BOqGNyjQs1WawwtB2a0t0bFRjOzakYLaQf00mgw4aaT5m6X3N59A7E1m5w3wzYiDSjXwoqCEX3tcBzV546WqAE1R08dJ0WhxAZXzd7Jz4OMlgRZCt7d_6RoI2qjQkZhA56udpnjOfFfcU0ly264TTeQx-AGOxbgoq54GWrET6JNimAdIoIjCOSA13WmqB0_wVvUDtnhMNDQT-rebZekgzq6RXw0jHgvoAwLR38KXwgw8_Vf2TXLGiHV5jWaP1FLlCVGcvQn4M5S3KTDR7iOg6s5fJy41fqJW-o8M3E74b5flTjEL2odYizKbsQnRRzC2MfX48j7MOA0rnDE7esIf3vLKwVj-VP7M7v1PbNbvqe5ETD3eKVGLlZq6h2zYWv79Z-fw3KE1_eR_PkLAfsCR6MFAAA.O9qyS26de7ocj3YnsZ-xFhtWpJfx5ONj9lcHH00s4ylig6OEhC25f-fawYqBXjgmsjFZZ6azlTA8KZNVrq3F9rdf-onFpLiuTobQaPAaOMbP7uYlq_6R62NlvA232ZzKsgsWBlmjpKtZn5GQtXnVSD_d0XzezluXrebSJdLM_uoJZsIvWO4bNPgcfLs2A9LiB190GpVNqrPlG3VdM4HwIk6DhSAXBWXJyoqSchdUszaul0CkPcmnw46P8IFv2MiwQA-3V7Q4Y5Jbo5SougqA8gtIO0u1g5fTqAcm88tnYz_7RxtXiF6uGP3RqlTTU-qpsi9w74NMczW9Hdf9q2O9by2JSqwhRsn8ud8wp5a3HC5rC4FjSPQKFTYNSr7LrNnlC0aHYP1k2c1J48t75EoNmlLYadIw87tSvMn7INmchOY9W-EXljEBP_OnW8x52-Madp4_q9-Cl3KWIlINpU4SREguWjl7-Y9w4OMn9dMs26N8ukJd-vgb_qlfto9qxQG9-CSCU1Ic8_LLaYItWGhsPaeym-S246ISYhN8uWpbEevJ7Jv0lvawqiYOxyIym80eWLqb9VvV_UiDg0C5XqwuYaA5cWn3sgxWwrxf7iLUOvGYAAJvKtflGqdIcYeJU09Z7iJZ7TqjrKoVPi9VwM1OBY-L46g10bEU9MAHCOnpjD4"
    
    
    func request<T: Decodable>(_ endpoint: Resource, type: T.Type, completion: @escaping (_ response: Result<T, Error>) -> Void) {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        urlRequest.httpBody = endpoint.httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {return
                completion(.failure(NSError(domain: "Error", code: 400, userInfo: ["reason": "No Data"])))
            }
            
            let response = Response(data: data)
            if let decoded = response.decode(type) {
                completion(.success(decoded))
            } else {
                completion(.failure(NSError(domain: "Error", code: 400, userInfo: ["reason": "Decoding Error"])))
            }
        }
        urlSession.resume()
    }
}

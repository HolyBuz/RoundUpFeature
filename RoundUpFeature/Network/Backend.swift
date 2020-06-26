import Foundation

struct Backend {
    private let accessToken = "Bearer eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAH1USY7bMBD8ykDn4UCbLUu33PKBPKBJNm3CFCmQlJNBkL-nJWqxnEFurqpeqrsp_850CFmXwaCZxN59hAjeaHvlYO8fwvXZexZGThEVr1VbYstUfrqwWuKFQcMVU-dctlKdkbc5BeOvIeuKU1uVTV4W5XumISaiuFSXiQAh3Gjjd2ck-h9aUu2WqoEUZ6YU56wWQrEWGmAnaIoKRCvqRlHt6O5oU0YJ2NScMiSvFKtzSrucTzlrUNVcQQEcK8qgsb4JgSGkrEt-OlVnbGjUHCirRtaey4KdVS2qvJQ5FuU0sHADTktJTtlttsos9Nh5BPn2IsTP4UXQEm3USqM_8kaHeGAWIKUnkx1KHTeQlBhB3HrcInf80-uIbzDGm_M60MmYtlI_tBzBpGAOBqxYrAnwkglno3cmNZqYRXNWad9D1M4yRzcdrQybFLbuK0itxRii69cRsQe9FDZIRuy1g2Ewnxuao3qwEiJ2Eg1SiRUumr9jnAYZPCr0SN7D_6RkI2mDAYG0gYhXP8_xnPivuKSiFzdYp-sxArmBThCc1QXPQw3wibhKCSxDJLAHMd3DdZkpaftPFj3YAGJ3SDTjo7l36yVxp_ZuCe8NE94KGCfo6E_hM8HcdP1XdsnyTmmzek3mD9Qc5VGgHuIBhKOUNhngQdcJ7Op2HwdusX7g5jrPTNoO3ferErv4Ra1dTEXFDeVoUDIae_96AsZIA47DAgdYvw7625tfKXNePrU_smvfI7vmR5waMREer9Qg1UKNPAhPW9uu__wc5iO8vo_sz1-y0MnHowUAAA.CRj6adkrmNqUBAgopHDE0ZOCKMoRhnC-2Yc1KuoOrgjI-8VgzbnPYMwhnlZGkdVAzMs3Uz4BUKJVnkKXYyLgFvd4yI2cG6Q9mFcefAIuPPdUFN3G_xP4pJXNBlG6c3ZqNhRhSKcMx6hO3lAc-KSlN1meENBtkqTRBxvjSW4CU3h0HbFV4lrJpNH407BVlIKSlbAN4QSppHs6kgEbIEeae6SZEiTSS2wiv_tdANNhZPZa-thPt5Sh34WyNJocsdLTV5ZKiQ74VdGzTbeZgw-zlEFDiS1Vym55zkFSfsO2_pTxJqRh445VpjvpSOsdrdKqOSECtfzjUNog-63kpyVbxBqasNr6VU3R5PGecjs-seXfkYlMTsGV9a5UXyMcBA8PmhwAVE7CNScpxtglEhv9gR1gTJ8ouCFZJZc4T0zpDsOUh7rxLd7mxISsWJp_bsnLmOiMFdynroNU-u62znny9dtdPItB5OgPYeczJq0QledpOsiFVK2ZN_MPHjdJj0vzAAhI0wqhJU2okzoqDvbKh6-s2FvQwLDIaWHpd-eek_G_T_6SpCzLE-thB2yPNNpdj3H4Re7c9vLoi5qfqnaxNlBwf7660W0TUmQlPibeAMU_UoOHs79KVErc7iZvoqrzhuu7_VGwnJwDuXrByXgPa5oYBUgtXTqcIWvohztdul0"
    
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

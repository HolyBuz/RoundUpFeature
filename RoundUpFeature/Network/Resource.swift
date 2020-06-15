import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

class Resource {
    private var urlComponent: URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = path
        urlComponent.queryItems = queryItems
        return urlComponent
    }
    
    var queryItems: [URLQueryItem]? {
        guard let parameters = parameters else { return nil }
        
        return parameters.map { key, value in
            return URLQueryItem(name: key, value: value as? String)
        }
    }
    
    var url: URL {
        return urlComponent.url!
    }
    
    var httpBody: Data?
    
    var httpMethod: HTTPMethod
    
    private var host = "api-sandbox.starlingbank.com"
    private var scheme = "https"
    private let path: String
    private let parameters: [String: Any]?
    
    init(prefix: String = "api", version: String = "v2", httpMethod: HTTPMethod = .GET , path: String, parameters: [String: String]? = nil, data: Data? = nil) {
        self.path =  "/" + prefix + "/" + version + "/" + path
        self.parameters = parameters
        self.httpBody = data
        self.httpMethod = httpMethod
    }
}

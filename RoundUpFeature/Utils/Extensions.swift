import UIKit

//MARK- UITableView
extension UITableView {
    
    func registerCell<T: UITableViewCell>(ofType type: T.Type) {
        let cellName = String(describing: T.self)
        
        if Bundle.main.path(forResource: cellName, ofType: "nib") != nil {
            let nib = UINib(nibName: cellName, bundle: Bundle.main)
            
            register(nib, forCellReuseIdentifier: cellName)
        } else {
            register(T.self, forCellReuseIdentifier: cellName)
        }
    }
    
    func dequeueCell<T: UITableViewCell>(ofType type: T.Type) -> T     {
        let cellName = String(describing: T.self)
        
        return dequeueReusableCell(withIdentifier: cellName) as! T
    }
}

extension Decodable {
    static func fromJSON<T: Decodable>(bundle: Bundle, filename: String, type: String = "json") -> T? {
        guard let path = bundle.path(forResource: filename, ofType: type),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}

extension Date {
    static func oneWeekAgo() -> Self? {
        return Calendar.current.date(byAdding: .day, value: -7, to: Date())
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        return dateFormatter.string(from: self)
    }
}

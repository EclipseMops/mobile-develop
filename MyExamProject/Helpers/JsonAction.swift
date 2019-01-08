import UIKit
import Alamofire

class JsonAction {
    
    static func newGet(address: String, args: [String : String] = [:], requestHeaders: [String : String] = [:], view: ViewController? = nil, _ completionHandler: @escaping
        (_ response:DataResponse<Any>?) -> Void) {
        newRequest(address: address, args: args, requestHeaders: requestHeaders, method: "GET", view: view, {response in
            completionHandler(response)
        })
    }
    
    static func newPost(address: String, args: [String : String] = [:], requestHeaders: [String : String] = [:], view: ViewController? = nil, _ completionHandler: @escaping
        (_ response:DataResponse<Any>?) -> Void) {
        newRequest(address: address, args: args, requestHeaders: requestHeaders, method: "POST", view: view, {response in
            completionHandler(response)
        })
    }
    
    static func newRequest(address: String, args: [String : String] = [:], requestHeaders: [String : String] = [:], method: String, view : ViewController? = nil, _ completionHandler: @escaping (_ response:DataResponse<Any>?) -> Void) {
        if(view != nil) {
            view?.showLoadingView()
        }
        let url = URL(string: address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        var headers = request.allHTTPHeaderFields ?? [:]
        headers = requestHeaders
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        let encoder = JSONEncoder()
        if(args.count != 0) {
            let jsonData = try! encoder.encode(args)
            request.httpBody = jsonData
        }
        Alamofire.request(request).responseJSON { response in
            if(view != nil) {
                view?.hideLoadingView()
            }
            print(response)
            if(response.result.isSuccess) {
                completionHandler(response)
            } else {
                completionHandler(nil)
            }
        }
    }
}

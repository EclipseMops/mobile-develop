import UIKit

class Instruments {
    
    static func getIPAddress(_ completionHandler: @escaping
        (_ response:String?) -> Void) {
        JsonAction.newGet(address: "http://ip-api.com/json", args: [:], {response in
            print(response)
            if(response == nil) {
                completionHandler(nil)
            } else {
                if let json = response?.value as? [String : Any] {
                    completionHandler(json["query"] as? String ?? nil)
                } else {
                    completionHandler(nil)
                }
            }
        })
    }
    
}

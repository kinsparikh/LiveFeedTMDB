
import UIKit
import SystemConfiguration

typealias ServiceResponse = (JSON,Data?,ErrorCase?) -> Void
public let decoder = JSONDecoder()

enum ErrorCase: String {
    case NoError = "success"
    case NoDataAvailable = "NoDataAvailable"
    case NoRecordsAvailable = "NoRecordsAvailable"
    case NoInternetConnection = "NoInternetConnection"
    case SomethingWentWrong = "SomethingWentWrong"
    case RequestTimedOut = "RequestTimedOut"
}

//dict for Log
let dict : [AnyHashable: Any] = ["appVersion": "1.0.0", "OSVersion" : "13.1.2", "NetworkMode" : "Mobile Network"]


class RestAPIManager: NSObject {
    
    static let sharedInstance = RestAPIManager()
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    
    func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        
        if !Connectivity.isConnectedToInternet()  {
            onCompletion(JSON.null,nil, ErrorCase.NoInternetConnection)
            return
        }
        //print("path = \(path)")
        
        let url = URL(string: path)
        var request = URLRequest(url: url!)
            
            let appID = UserDefaults.standard.string(forKey: "myappId")
            request.setValue(appID, forHTTPHeaderField: "appID")
            if #available(iOS 11.0, *) {
                request.setValue("br", forHTTPHeaderField: "Accept-Encoding")
            }else{
                request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            //print("HEADERS:: \(String(describing: request.allHTTPHeaderFields))")
            
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 20.0
            let session = URLSession(configuration: sessionConfig)
//            TICK()
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
//                TOCK()
                if let jsonData = data {
                    if let httpUrlResponse = response as? HTTPURLResponse{
                        
                        if(error != nil){
                            //print("Error Occurred: \(String(describing: error?.localizedDescription))")
                        }
                        else{
                            //print("HEADERS :: \(httpUrlResponse.allHeaderFields)")
                            let dctnry = httpUrlResponse.allHeaderFields
//                            let Date = dctnry["Date"]
//                            UserDefaults.standard.set(Date, forKey: "datetime")
                        }
                    }
                    let json:JSON = JSON(data: jsonData)
                    //print(json)
                    onCompletion(json, data, ErrorCase.NoError)
                } else {
                    
                    let code = (error as NSError?)?.code
                    
                    switch code{
                    case NSURLErrorTimedOut?:
                        onCompletion(JSON.null, data, ErrorCase.RequestTimedOut)
                        break
                    default:
                       
                        if let dictObj = dict as? [String:String]{
                            //Answers.logCustomEvent(withName: "APIFailure", customAttributes:dictObj)
                        }
                        onCompletion(JSON.null, data, ErrorCase.SomethingWentWrong)
                    }
                }
            })
            task.resume()

    }
    

}

class Connectivity {
    
    class func isConnectedToInternet() -> Bool {

                var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
                zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
                zeroAddress.sin_family = sa_family_t(AF_INET)

                let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                    $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                    }
                }

                var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
                if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                    return false
                }

                // Working for Cellular and WIFI
                let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
                let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
                let ret = (isReachable && !needsConnection)

                return ret

            }
}

//
//  APIRequestClient.swift
//  TeenageSafety
//
//  Created by user on 19/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

let kNoInternetError = "No Internet available."
typealias SUCCESS = (_ response:Any)->()
typealias FAIL = (_ response:Any)->()
let kUserDefault = UserDefaults.standard



class APIRequestClient: NSObject {
    enum RequestType {
        case POST
        case GET
        case PUT
        case DELETE
        case PATCH
        case OPTIONS
    }
    static let shared:APIRequestClient = APIRequestClient()
    
    //Post LogIn API
    func sendRequest(requestType:RequestType,queryString:String?,parameter:[String:AnyObject]?,isHudeShow:Bool,success:@escaping SUCCESS,fail:@escaping FAIL){
        guard CommonClass.shared.isConnectedToInternet else{
            ShowToast.show(toatMessage: kNoInternetError)
            //fail(["Error":kNoInternetError])
            return
        }
        if isHudeShow{
            DispatchQueue.main.async {
                ProgressHud.show()
            }
        }
        let urlString = kNewBaseURL + (queryString == nil ? "" : queryString!)
        
        var request = URLRequest(url: URL(string: urlString.removeWhiteSpaces())!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 60
        request.httpMethod = String(describing: requestType)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
    
 
        if let params = parameter{
            do{
                let parameterData = try JSONSerialization.data(withJSONObject:params, options:.prettyPrinted)
                request.httpBody = parameterData
            }catch{
                DispatchQueue.main.async {
                    ProgressHud.hide()
                }
                ShowToast.show(toatMessage: kCommonError)
                fail(["error":kCommonError])
            }
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                ProgressHud.hide()
            }
            if error != nil{
                ShowToast.show(toatMessage: "\(error!.localizedDescription)")
                //fail(["error":"\(error!.localizedDescription)"])
            }
            if let _ = data,let httpStatus = response as? HTTPURLResponse{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    (httpStatus.statusCode == 200) ? success(json):fail(json)
                }
                catch{
                    (httpStatus.statusCode == 200) ? success(["success":"success"]):fail(["error":kCommonError])                    
                }
            }else{
                ShowToast.show(toatMessage: kCommonError)
                fail(["error":kCommonError])
            }
        }
        task.resume()
    }
}

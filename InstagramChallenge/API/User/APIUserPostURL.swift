//
//  AuthRouter.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import Foundation
import Alamofire

enum APIUserPostURL: URLRequestConvertible {
    case signUp(realName: String, password: String, loginId: String, birthDate: String, phoneNumber: String)
    case signIn(loginId: String, password: String)
    
    var baseURL: URL {
        return URL(string: BASE_URL as! String)!
    }
    
    var endPoint: String {
        switch self {
        case .signUp:
            return "/app/sign-up"
        case .signIn:
            return "/app/sign-in"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        default:
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "Content-Type": "application/json"
            ]
            return headers
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .signUp(let realName, let password, let loginId, let birthDate, let phoneNumber):
            var params = Parameters()
            params["realName"] = realName
            params["password"] = password
            params["loginId"] = loginId
            params["birthDate"] = birthDate
            params["phoneNumber"] = phoneNumber
            return params
            
        case .signIn(let loginId, let password):
            var params = Parameters()
            params["loginId"] = loginId
            params["password"] = password
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)

        request.headers = headers
        request.method = method
        
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        return request
    }
}

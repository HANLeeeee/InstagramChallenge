//
//  APIUserGetURL.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/04.
//

import Foundation
import Alamofire

enum APIUserGetURL: URLRequestConvertible {
    
    case autoSignIn(accessToken: String)
    case searchUserID(loginId: String)
    case searchMyPage(accessToken: String, loginId: String)
    
    var baseURL: URL {
        return URL(string: "https://challenge-api.gridge.co.kr")!
    }
    
    var endPoint: String {
        switch self {
        case .autoSignIn:
            return "/app/auto-sign-in"
        case .searchUserID(_):
            return ""
        case .searchMyPage(_, let loginId):
            return "/app/users/\(loginId)/my-page"
        }
    }
    
    var url: URL {
        switch self {
        case .searchUserID(let loginId):
            return URL(string: "https://challenge-api.gridge.co.kr/app/check-duplicate-login-id?loginId=\(loginId)")!
            
        default:
            return baseURL.appendingPathComponent(endPoint)
        }
    }
        
    var headers: HTTPHeaders {
        switch self {
        case .autoSignIn(let accessToken):
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "x-access-token": accessToken
            ]
            return headers
            
        case .searchUserID(_):
            let headers: HTTPHeaders = [
                "accept": "*/*"
            ]
            return headers
            
        case .searchMyPage(let accessToken, _):
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "x-access-token": accessToken
            ]
            return headers
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .searchUserID(let loginId):
            var params = Parameters()
            params["loginId"] = loginId

            return params
        
        default:
            return Parameters()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var request = URLRequest(url: url)

        request.headers = headers
        request.method = method
        
//        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: []).h
//        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
//        request.httpBody = try URLEncoding.queryString.encode(request, with: parameters).httpBody
//        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        debugPrint(request)
        return request
    }
}

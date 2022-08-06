//
//  APIKakaoPostURL.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/07.
//

import Foundation
import Alamofire

enum APIKakaoPostURL: URLRequestConvertible {
    
    case kakaoSignUp(accessToken: String, realName: String, birthDate: String, loginId: String, phoneNumber: String)
    case kakaoSignIn(accessToken: String)
    
    var baseURL: URL {
        return URL(string: "https://challenge-api.gridge.co.kr")!
    }
    
    var endPoint: String {
        switch self {
        case .kakaoSignUp:
            return "/app/kakao-sign-up"
        case .kakaoSignIn:
            return "/app/kakao-sign-in"
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
        case .kakaoSignUp(let accessToken, let realName, let birthDate, let loginId, let phoneNumber):
            var params = Parameters()
            params["accessToken"] = accessToken
            params["realName"] = realName
            params["birthDate"] = birthDate
            params["loginId"] = loginId
            params["phoneNumber"] = phoneNumber
            return params
            
        case .kakaoSignIn(let accessToken):
            var params = Parameters()
            params["accessToken"] = accessToken
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

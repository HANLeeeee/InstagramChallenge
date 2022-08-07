//
//  APIChatPostURL.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import Foundation
import Alamofire

enum APIChatPostURL: URLRequestConvertible {
    case createChat(accessToken: String, content: String)
    
    var baseURL: URL {
        return URL(string: "https://challenge-api.gridge.co.kr")!
    }
    
    var endPoint: String {
        switch self {
        case .createChat:
            return "/app/chat"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .createChat(let accessToken, _):
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "Content-Type": "application/json",
                "x-access-token": "\(accessToken)"
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
        case .createChat(_, let content):
            var params = Parameters()
            params["content"] = content
            
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)

        request.headers = headers
        request.method = method
        
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        return request
    }
}

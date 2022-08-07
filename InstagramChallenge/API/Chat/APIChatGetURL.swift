//
//  APIChatGetURL.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import Foundation
import Alamofire

enum APIChatGetURL: URLRequestConvertible {
    case searchChat(accessToken: String, pageIndex: Int, size: Int)
    
    var baseURL: URL {
        return URL(string: "https://challenge-api.gridge.co.kr")!
    }
    
    var endPoint: String {
        switch self {
        case .searchChat:
            return "/app/chats"
        }
    }
    
    var url: URL {
        switch self {
        case .searchChat(_, let pageIndex, let size):
            return URL(string: "\(baseURL)\(endPoint)?pageIndex=\(pageIndex)&size=\(size)")!
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .searchChat(let accessToken, _, _):
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "x-access-token": accessToken
            ]
            return headers
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchChat:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .searchChat(_, let pageIndex, let size):
            var params = Parameters()
            params["pageIndex"] = pageIndex
            params["size"] = size
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)

        request.headers = headers
        request.method = method
        
        return request
    }

}

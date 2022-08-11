//
//  APIFeedPatchURL.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import Foundation
import Alamofire

enum APIFeedPatchURL: URLRequestConvertible {
    case modifyFeed(accessToken: String, feedId: Int, feedText: String)
    case deleteFeed(accessToken: String, feedId: Int)
    
    var baseURL: URL {
        return URL(string: BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .modifyFeed(_, let feedId, _):
            return "/app/feeds/\(feedId)"
        case .deleteFeed(_, let feedId):
            return "/app/feeds/\(feedId)/delete-status"
        }
    }
        
    var headers: HTTPHeaders {
        switch self {
        case .modifyFeed(let accessToken, _, _):
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "Content-Type": "application/json",
                "x-access-token": accessToken
            ]
            return headers
            
        case .deleteFeed(let accessToken, _):
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
            return .patch
        }
    }
    
    
    var parameters: Parameters {
        switch self {
        case .modifyFeed(_, _, let feedText):
            var params = Parameters()
            params["feedText"] = feedText

            return params

        case .deleteFeed(_, _):
            return Parameters()

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

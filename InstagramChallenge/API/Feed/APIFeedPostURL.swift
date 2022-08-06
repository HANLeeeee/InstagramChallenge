//
//  APIFeedPostURL.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import Foundation
import Alamofire

enum APIFeedPostURL: URLRequestConvertible {
    
    case createFeed(accessToken: String, feedText: String, contentsUrls: [String])
    case createComment(accessToken: String, feedId: Int, commentText: String)
    
    var baseURL: URL {
        return URL(string: "https://challenge-api.gridge.co.kr")!
    }
    
    var endPoint: String {
        switch self {
        case .createFeed:
            return "/app/feed"
        case .createComment(_, let feedId, _):
            return "/app/feeds/\(feedId)/comment"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .createFeed(let accessToken, _, _):
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "Content-Type": "application/json",
                "x-access-token": "\(accessToken)"
            ]
            return headers
            
        case .createComment(let accessToken, _, _):
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
        case .createFeed(_, let feedText, let contentsUrls):
            var params = Parameters()
            params["feedText"] = feedText
            params["contentsUrls"] = contentsUrls
            return params
            
        case .createComment(_, _, let commentText):
            var params = Parameters()
            params["commentText"] = commentText
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

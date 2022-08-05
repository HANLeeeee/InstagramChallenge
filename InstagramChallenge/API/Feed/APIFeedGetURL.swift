//
//  APIFeedGetURL.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import Foundation
import Alamofire

enum APIFeedGetURL: URLRequestConvertible {
    
    case getFeeds(accessToken: String, pageIndex: Int, size: Int)
    case getFeedsUser(accessToken: String, pageIndex: Int, size: Int, loginId: String)
    case getComments(accessToken: String, feedId: Int, pageIndex: Int, size: Int)
    
    var baseURL: String {
        return "https://challenge-api.gridge.co.kr"
    }
    
    var endPoint: String {
        switch self {
        case .getFeeds:
            return "/app/feeds"
        case .getFeedsUser:
            return "/app/feeds/user"
        case .getComments(_, let feedId, _, _):
            return "/app/feeds/\(feedId)/comments"
        }
    }
    
    var url: URL {
        switch self {
        case .getFeeds(_, let pageIndex, let size):
            return URL(string: "\(baseURL)\(endPoint)?pageIndex=\(pageIndex)&size=\(size)")!
        case .getFeedsUser(_, let pageIndex, let size, let loginId):
            return URL(string: "\(baseURL)\(endPoint)?pageIndex=\(pageIndex)&size=\(size)&loginId=\(loginId)")!
        case .getComments(_, let feedId, let pageIndex, let size):
            return URL(string: "\(baseURL)\(endPoint)?feedId=\(feedId)&pageIndex=\(pageIndex)&size=\(size)")!
        }
    }
        
    var headers: HTTPHeaders {
        switch self {
        case .getFeeds(let accessToken, _, _):
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "x-access-token": accessToken
            ]
            return headers
            
        case .getFeedsUser(let accessToken, _, _, _):
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "x-access-token": accessToken
            ]
            return headers
            
        case .getComments(let accessToken, _, _, _):
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
    
    
//    var parameters: Parameters {
//        switch self {
//        case .getFeeds(_, let pageIndex, let size):
//            var params = Parameters()
//            params["pageIndex"] = pageIndex
//            params["size"] = size
//            
//            return params
//            
//        case .getFeedsUser(_, let pageIndex, let size, let loginId):
//            var params = Parameters()
//            params["pageIndex"] = pageIndex
//            params["size"] = size
//            params["loginId"] = loginId
//            return params
//            
//        case .getComments(_, let feedId, let pageIndex, let size):
//            var params = Parameters()
//            params["feedId"] = feedId
//            params["pageIndex"] = pageIndex
//            params["size"] = size
//            return params
//        }
//    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)

        request.headers = headers
        request.method = method
        
        return request
    }
}

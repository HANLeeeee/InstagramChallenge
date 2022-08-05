//
//  APIFeedGet.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import Foundation
import Alamofire

class APIFeedGet {
//case getFeeds(accessToken: String, pageIndex: Int, size: Int)
//case getFeedsUser(accessToken: String, pageIndex: Int, size: Int, loginId: String)
//case getComments(accessToken: String, feedId: Int, pageIndex: Int, size: Int)
    
    
    func getFeeds(accessToken: String, pageIndex: Int, size: Int, completion: @escaping (Result<[FeedResponseResult], AFError>) -> Void) {
        AF.request(APIFeedGetURL.getFeeds(accessToken: accessToken, pageIndex: pageIndex, size: size))
            .validate()
            .responseDecodable(of: FeedResponse.self) { response in
//                debugPrint(response)
            switch response.result {
            case .success(let result):
                completion(.success(result.result))
                
            case .failure(let error):
                completion(.failure(error))
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}

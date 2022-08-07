//
//  APIFeedPost.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import Foundation
import Alamofire

class APIFeedPost {
    
    //MARK: 피드 생성
    func createFeed(accessToken: String, feedText: String, contentsUrls: [String], completion: @escaping (Result<FeedResponse, AFError>) -> Void) {
        AF.request(APIFeedPostURL.createFeed(accessToken: accessToken, feedText: feedText, contentsUrls: contentsUrls))
            .validate()
            .responseDecodable(of: FeedResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }

    //MARK: 댓글 생성
    func createComment(accessToken: String, feedId: Int, commentText: String, completion: @escaping (Result<FeedResponse, AFError>) -> Void) {
        AF.request(APIFeedPostURL.createComment(accessToken: accessToken, feedId: feedId, commentText: commentText))
            .validate()
            .responseDecodable(of: FeedResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))

            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}

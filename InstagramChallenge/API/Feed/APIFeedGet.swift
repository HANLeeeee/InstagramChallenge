//
//  APIFeedGet.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import Foundation
import Alamofire

class APIFeedGet {
    //MARK: 피드 조회
    func getFeeds(accessToken: String, pageIndex: Int, size: Int, completion: @escaping (Result<[FeedResponseResult], AFError>) -> Void) {
        AF.request(APIFeedGetURL.getFeeds(accessToken: accessToken, pageIndex: pageIndex, size: size))
            .validate()
            .responseDecodable(of: FeedResponse.self) { response in
//                debugPrint(response)
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    completion(.success(result.result!))
                }
            case .failure(let error):
                completion(.failure(error))
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: 특정 유저 피드 조회
    func getFeedsUser(accessToken: String, pageIndex: Int, size: Int, loginId: String, completion: @escaping (Result<[FeedResponseResult], AFError>) -> Void) {
        AF.request(APIFeedGetURL.getFeedsUser(accessToken: accessToken, pageIndex: pageIndex, size: size, loginId: loginId))
            .validate()
            .responseDecodable(of: FeedResponse.self) { response in
//                debugPrint(response)
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    completion(.success(result.result!))
                }
            case .failure(let error):
                completion(.failure(error))
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }

    //MARK: 댓글 조회
    func getComments(accessToken: String, feedId: Int, pageIndex: Int, size: Int, completion: @escaping (Result<[CommentResponseResult], AFError>) -> Void) {
        AF.request(APIFeedGetURL.getComments(accessToken: accessToken, feedId: feedId, pageIndex: pageIndex, size: size))
            .validate()
            .responseDecodable(of: CommentResponse.self) { response in
//                debugPrint(response)
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    completion(.success(result.result ?? []))
                }
            case .failure(let error):
                completion(.failure(error))
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}

//
//  APIFeedPatch.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import Foundation
import Alamofire



class APIFeedPatch {
    
    //MARK: 피드 수정
    func modifyFeed(accessToken: String, feedId: Int, feedText: String, completion: @escaping (Result<FeedResponse, AFError>) -> Void) {
        AF.request(APIFeedPatchURL.modifyFeed(accessToken: accessToken, feedId: feedId, feedText: feedText))
            .validate()
            .responseDecodable(of: FeedResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let result):
                print(result)
                if result.isSuccess {
                    completion(.success(result))
                }
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }

    //MARK: 피드 삭제
    func deleteFeed(accessToken: String, feedId: Int) {
        AF.request(APIFeedPatchURL.deleteFeed(accessToken: accessToken, feedId: feedId))
            .validate()
            .responseDecodable(of: FeedResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    print("삭제성공")
                } else {
                    print("삭제문제발생")
                }
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}

//
//  APIChatPost.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import Foundation
import Alamofire

class APIChatPost {
    //MARK: 채팅 생성
    func createChat(accessToken: String, content: String, completion: @escaping (Result<ChatPostResponse, AFError>) -> Void) {
        AF.request(APIChatPostURL.createChat(accessToken: accessToken, content: content))
            .validate()
            .responseDecodable(of: ChatPostResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}

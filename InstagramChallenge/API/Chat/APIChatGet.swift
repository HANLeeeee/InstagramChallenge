//
//  APIChat.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import Foundation
import Alamofire

class APIChatGet {
    
    //MARK: 채팅 조회
    func searchChat(accessToken: String, pageIndex: Int, size: Int, completion: @escaping (Result<[ChatResponseResult], AFError>) -> Void) {
        AF.request(APIChatGetURL.searchChat(accessToken: accessToken, pageIndex: pageIndex, size: size))
            .validate()
            .responseDecodable(of: ChatResponse.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    completion(.success(result.result))
                }
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}

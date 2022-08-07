//
//  APIUserGet.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/04.
//

import Foundation
import Alamofire

class APIUserGet {
    //MARK: 자동로그인
    func autoSignIn(accessToken: String, completion: @escaping (Result<UserResponse, AFError>) -> Void) {
        AF.request(APIUserGetURL.autoSignIn(accessToken: accessToken))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                print(response)
            switch response.result {
            case .success(let result):
                completion(.success(result))
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }

    //MARK: 아이디 중복 조회
    func searchUserID(loginId: String, completion: @escaping (Result<UserResponse, AFError>) -> Void) {
        AF.request(APIUserGetURL.searchUserID(loginId: loginId))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: 마이페이지 조회
    func searchMyPage(accessToken: String, loginId: String, completion: @escaping (Result<UserResponse, AFError>) -> Void) {
        AF.request(APIUserGetURL.searchMyPage(accessToken: accessToken, loginId: loginId))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))

            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}

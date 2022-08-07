//
//  AuthAPI.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import Foundation
import Alamofire

class APIUserPost {
    //MARK: 자체 회원가입
    func signUp(realName: String, password: String, loginId: String, birthDate: String, phoneNumber: String, completion: @escaping (Result<UserResponse, AFError>) -> Void) {
        AF.request(APIUserPostURL.signUp(realName: realName, password: password, loginId: loginId, birthDate: birthDate, phoneNumber: phoneNumber))
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

    //MARK: 자체 로그인
    func signIn(loginId: String, password: String, completion: @escaping (Result<UserResponse, AFError>) -> Void) {
        AF.request(APIUserPostURL.signIn(loginId: loginId, password: password))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
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

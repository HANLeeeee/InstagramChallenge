//
//  APIKakaoPost.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/07.
//

import Foundation
import Alamofire

class APIKakaoPost {
    //MARK: 카카오 회원가입
    func kakaoSignUp(accessToken: String, realName: String, birthDate: String, loginId: String, phoneNumber: String) {
        AF.request(APIKakaoPostURL.kakaoSignUp(accessToken: accessToken, realName: realName, birthDate: birthDate, loginId: loginId, phoneNumber: phoneNumber))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let result):
                print(result)
                if result.isSuccess {
                    if let result = result.result {
                        print(result.jwt!)
    //                        UserDefaultsData.shared.setToken(userID: loginId, jwt: result.jwt!)
    //                        joinFinalVC.joinsuccessAPI(result)
                    }
                } else {
                    print(result.code)
    //                    joinFinalVC.joinfailureAPI(result.code)
                }
                
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }

    //MARK: 카카오 로그인
    func kakaoSignIn(accessToken: String, completion: @escaping (Result<UserResponse, AFError>) -> Void) {
        AF.request(APIKakaoPostURL.kakaoSignIn(accessToken: accessToken))
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

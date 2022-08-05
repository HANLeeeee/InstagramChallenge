//
//  APIUserGet.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/04.
//

import Foundation
import Alamofire

class APIUserGet {
    var autoResult = false

    func autoSignIn(accessToken: String, completion: @escaping (Result<UserResponse, AFError>) -> Void) {
        AF.request(APIUserGetURL.autoSignIn(accessToken: accessToken))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                print(response)
            switch response.result {
            case .success(let result):
                completion(.success(result))
                print(result)
//                if result.isSuccess {
//
//                    if let result = result.result {
//                        print("\(self.autoResult) 우어1 \(result)")
//                        self.autoResult = true
//                    }
//                } else {
//                    self.autoResult = false
//                    print("\(self.autoResult) 우어2 \(result.message)")
//                }

            case .failure(let error):
                self.autoResult = false
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }

    func searchUserID(loginId: String, joinUserIDVC: JoinUserIDViewController) {
        AF.request(APIUserGetURL.searchUserID(loginId: loginId))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
            debugPrint(response)

            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    joinUserIDVC.searchUserIDsuccessAPI(loginId)
                } else {
                    joinUserIDVC.searchUserIDfailureAPI(result.code, loginId)
                }
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
    
    func searchMyPage(accessToken: String, loginId: String, mypageVC: MypageViewController) {
        AF.request(APIUserGetURL.searchMyPage(accessToken: accessToken, loginId: loginId))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
            debugPrint(response)

            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    mypageVC.searchMyPagesuccessAPI(result.result!)
                } else {
                    print(result.code, result.message)
                }
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}

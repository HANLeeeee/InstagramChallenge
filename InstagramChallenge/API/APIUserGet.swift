//
//  APIUserGet.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/04.
//

import Foundation
import Alamofire

class APIUserGet {
    
    func autoSignIn(accessToken: String) {
        AF.request(APIUserGetURL.autoSignIn(accessToken: accessToken))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                print(response)
            switch response.result {
            case .success(let result):
                print(result)
                if result.isSuccess {
                    if let result = result.result {
                        print(result)
                    }
                } else {
                    print(result.message)
                }

            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }

    func searchUserID(loginId: String) {
        AF.request(APIUserGetURL.searchUserID(loginId: loginId))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
            debugPrint(response)

            switch response.result {
            case .success(let result):
                if result.isSuccess {
                    if let result = result.result {
                        JoinUserIDViewController().searchUserIDsuccessAPI(result)
                    }
                } else {
                    JoinUserIDViewController().searchUserIDfailureAPI(result.code)
                }
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}

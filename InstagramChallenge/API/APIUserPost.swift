//
//  AuthAPI.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import Foundation
import Alamofire

class APIUserPost {
    func signUp(realName: String, password: String, loginId: String, birthDate: String, phoneNumber: String) {
        AF.request(APIUserPostURL.signUp(realName: realName, password: password, loginId: loginId, birthDate: birthDate, phoneNumber: phoneNumber))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                print(response)
            switch response.result {
            case .success(let result):
                print(result)
                if result.isSuccess {
                    if let result = result.result {
                        print(result)
                        JoinFinalViewController().joinsuccessAPI(result)
                    }
                } else {
                    JoinFinalViewController().joinfailureAPI(result.code)
                }
                
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }

    func signIn(loginId: String, password: String) {
        AF.request(APIUserPostURL.signIn(loginId: loginId, password: password))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                print(response)
            switch response.result {
            case .success(let result):
                print(result)
                if result.isSuccess {
                    if let result = result.result {
                        print(result)
                        LoginViewController().loginsuccessAPI(result)
                    }
                } else {
                    LoginViewController().loginfailureAPI(result.code)
                }
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
    
}

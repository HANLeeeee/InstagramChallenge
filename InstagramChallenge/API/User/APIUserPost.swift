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
    func signUp(realName: String, password: String, loginId: String, birthDate: String, phoneNumber: String, joinFinalVC: JoinFinalViewController) {
        AF.request(APIUserPostURL.signUp(realName: realName, password: password, loginId: loginId, birthDate: birthDate, phoneNumber: phoneNumber))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let result):
                print(result)
                if result.isSuccess {
                    if let result = result.result {
                        UserDefaultsData.shared.setToken(userID: loginId, jwt: result.jwt!)
                        joinFinalVC.joinsuccessAPI(result)
                    }
                } else {
                    joinFinalVC.joinfailureAPI(result.code)
                }
                
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }

    //MARK: 자체 로그인
    func signIn(loginId: String, password: String, loginVC: LoginViewController) {
        AF.request(APIUserPostURL.signIn(loginId: loginId, password: password))
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let result):
                print(result)
                if result.isSuccess {
                    if let result = result.result {
                        UserDefaultsData.shared.setToken(userID: result.loginId!, jwt: result.jwt!)
                        loginVC.loginsuccessAPI(result)
                    }
                } else {
                    loginVC.loginfailureAPI(result.code)
                }
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}
